package bino.laryssa.backend.model.dto;

import java.time.LocalDate;
import java.time.LocalTime;

import bino.laryssa.backend.model.enums.DoseInterval;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateMedicationRequest {
    @NotBlank(message = "O nome do medicamento é obrigatório")
    private String name;
    @NotBlank(message = "A dosagem é obrigatória")
    private String dosage;
    @NotNull(message = "O intervalo de dose é obrigatório")
    private DoseInterval doseInterval;
    private String activeIngredients;
    private String administrationRoute;
    private String pharmaceuticalForm;
    private String medicationImage;
    private LocalDate startDate;
    private LocalDate endDate;
    private LocalTime startTime;
    private int treatmentDurationDays;
    private int stockQuantity;
    private Long userId;
}
