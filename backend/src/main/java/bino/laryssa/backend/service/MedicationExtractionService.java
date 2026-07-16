package bino.laryssa.backend.service;

import bino.laryssa.backend.model.dto.ExtractedMedicationDTO;
import bino.laryssa.backend.model.dto.ExtractedMedicationsResponse;
import bino.laryssa.backend.model.enums.DoseInterval;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.genai.Client;
import com.google.genai.types.Content;
import com.google.genai.types.GenerateContentConfig;
import com.google.genai.types.GenerateContentResponse;
import com.google.genai.types.Part;
import com.google.genai.types.Schema;
import com.google.genai.types.Type;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@Service
public class MedicationExtractionService {

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.model:gemini-3.1-flash-lite}")
    private String modelId;

    private final ObjectMapper objectMapper = new ObjectMapper();

    // RN007: apenas JPG, PNG ou PDF são aceitos
    private static final Set<String> ALLOWED_MIME_TYPES = Set.of(
            "application/pdf", "image/jpeg", "image/png"
    );

    public ExtractedMedicationsResponse extractMedicationData(MultipartFile file) throws IOException {
        String mimeType = file.getContentType();
        if (mimeType == null || !ALLOWED_MIME_TYPES.contains(mimeType)) {
            throw new IllegalArgumentException(
                    "Formato não suportado. Envie apenas JPG, PNG ou PDF.");
        }

        String rawJson = callGemini(file.getBytes(), mimeType);
        ExtractedMedicationsResponse parsed = objectMapper.readValue(rawJson, ExtractedMedicationsResponse.class);

        for (ExtractedMedicationDTO med : parsed.getMedications()) {
            Optional<DoseInterval> mapped = DoseIntervalMapper.map(med.getDoseIntervalText());
            if (mapped.isPresent()) {
                med.setDoseInterval(mapped.get().name());
                med.setRequiresManualInterval(false);
            } else {
                med.setDoseInterval(null);
                med.setRequiresManualInterval(true);
            }

            med.setRequiresManualDosage(med.getDosage() == null);
        }

        return parsed;
    }

    private String callGemini(byte[] fileBytes, String mimeType) throws IOException {
        try (Client client = Client.builder().apiKey(apiKey).build()) {

            Schema stringNullable = Schema.builder().type(Type.Known.STRING).nullable(true).build();

            Schema medicationSchema = Schema.builder()
                    .type(Type.Known.OBJECT)
                    .properties(Map.of(
                            "name", stringNullable,
                            "dosage", stringNullable,
                            "doseIntervalText", stringNullable,
                            "doseAmount", Schema.builder().type(Type.Known.NUMBER).nullable(true).build(),
                            "doseUnit", stringNullable,
                            "activeIngredients", stringNullable,
                            "pharmaceuticalForm", stringNullable,
                            "administrationRoute", stringNullable,
                            "treatmentDurationDaysText", stringNullable
                    ))
                    .required(List.of("name", "dosage", "doseIntervalText"))
                    .build();

            Schema responseSchema = Schema.builder()
                    .type(Type.Known.OBJECT)
                    .properties(Map.of(
                            "medications", Schema.builder()
                                    .type(Type.Known.ARRAY)
                                    .items(medicationSchema)
                                    .build()
                    ))
                    .required(List.of("medications"))
                    .build();

            GenerateContentConfig config = GenerateContentConfig.builder()
                    .temperature(0.1f)
                    .maxOutputTokens(4096)
                    .responseMimeType("application/json")
                    .responseSchema(responseSchema)
                    .build();

            String prompt = """
                    Você é um especialista em leitura de receitas médicas.
                    Analise a receita (imagem ou PDF) e extraia os medicamentos prescritos.

                    Para cada medicamento, extraia:
                    - name: nome do medicamento
                    - dosage: concentração/dosagem indicada, ex. "500mg"
                    - doseIntervalText: frequência de administração exatamente como
                      descrita na receita, ex. "a cada 8 horas" ou "12/12 horas"
                    - doseAmount: quantidade administrada por dose, como número, ex. 1 (para "1 cp")
                      ou 10 (para "10 ml")
                    - doseUnit: unidade correspondente ao doseAmount, ex. "comprimido", "ml", "jato"
                    - activeIngredients: princípio(s) ativo(s), se indicado(s)
                    - pharmaceuticalForm: forma farmacêutica, ex. "comprimido", "cápsula", "solução", "spray"
                    - administrationRoute: via de administração, ex. "oral", "nasal", "tópica"
                    - treatmentDurationDaysText: duração do tratamento em dias, exatamente como
                      descrita na receita, ex. "3 dias" ou "5 dias". Se for uso contínuo, retorne null.

                    Se um campo não puder ser determinado com confiança, retorne o valor null
                    (não use texto como "não especificado", "N/A" ou similar — o valor deve ser
                    literalmente null).

                    Só não inclua um medicamento na lista se o nome (name) não estiver
                    legível ou presente no documento.
                    Não invente informações que não estejam no documento.
                    """;

            Content content = Content.fromParts(
                    Part.fromText(prompt),
                    Part.fromBytes(fileBytes, mimeType)
            );

            GenerateContentResponse response = client.models.generateContent(modelId, content, config);
            return response.text();
        }
    }
}