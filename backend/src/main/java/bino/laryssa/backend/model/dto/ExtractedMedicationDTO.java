package bino.laryssa.backend.model.dto;

import lombok.Data;

@Data
public class ExtractedMedicationDTO {
    private String name;
    private String dosage;
    private String doseIntervalText;
    private String doseInterval;
    private boolean requiresManualInterval;
    private boolean requiresManualDosage;
    private String activeIngredients;
    private String pharmaceuticalForm;
    private String administrationRoute;
    private Double doseAmount;
    private String doseUnit;
    private String treatmentDurationDaysText;
}