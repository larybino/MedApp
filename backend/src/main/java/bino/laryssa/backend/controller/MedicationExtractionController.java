package bino.laryssa.backend.controller;

import bino.laryssa.backend.model.dto.ExtractedMedicationsResponse;
import bino.laryssa.backend.service.MedicationExtractionService;

import java.io.IOException;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;


@RestController
@RequestMapping("/medications")
public class MedicationExtractionController {


    private final MedicationExtractionService extractionService;

    public MedicationExtractionController(MedicationExtractionService extractionService) {
        this.extractionService = extractionService;
    }

    @PostMapping(value = "/extract", consumes = "multipart/form-data")
    public ResponseEntity<?> extractMedicationData(@RequestParam("file") MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("Nenhum arquivo enviado.");
        }
        ExtractedMedicationsResponse result = extractionService.extractMedicationData(file);
        return ResponseEntity.ok(result);
    }
}