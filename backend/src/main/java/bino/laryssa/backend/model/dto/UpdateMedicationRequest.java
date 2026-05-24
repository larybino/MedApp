package bino.laryssa.backend.model.dto;

import java.time.LocalDate;
import java.time.LocalTime;

import bino.laryssa.backend.model.enums.DoseInterval;
import lombok.Data;

@Data
public class UpdateMedicationRequest {
    private String name;
    private String dosage;
    private DoseInterval doseInterval;
    private String activeIngredients;
    private String pharmaceuticalForm;
    private String administrationRoute;
    private LocalDate startDate;
    private LocalTime startTime;
    private Integer treatmentDurationDays;
    private Integer stockQuantity;
    private String medicationImage;
}
