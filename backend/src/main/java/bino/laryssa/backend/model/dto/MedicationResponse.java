package bino.laryssa.backend.model.dto;

import bino.laryssa.backend.model.Medication;
import bino.laryssa.backend.model.enums.DoseInterval;
import bino.laryssa.backend.model.enums.TreatmentStatus;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
public class MedicationResponse {
    private Long id;
    private String name;
    private String dosage;
    private DoseInterval doseInterval;
    private String activeIngredients;
    private String pharmaceuticalForm;
    private String administrationRoute;
    private LocalDate startDate;
    private LocalTime startTime;
    private LocalDate endDate;
    private Integer treatmentDurationDays;
    private Integer stockQuantity;
    private Integer currentStock;
    private boolean acquisitionConfirmed;
    private String medicationImage;
    private TreatmentStatus treatmentStatus;
    private Long userId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static MedicationResponse toResponse(Medication med) {
        MedicationResponse response = new MedicationResponse();
        response.setId(med.getId());
        response.setName(med.getName());
        response.setDosage(med.getDosage());
        response.setDoseInterval(med.getDoseInterval());
        response.setActiveIngredients(med.getActiveIngredients());
        response.setPharmaceuticalForm(med.getPharmaceuticalForm());
        response.setAdministrationRoute(med.getAdministrationRoute());
        response.setStartDate(med.getStartDate());
        response.setStartTime(med.getStartTime());
        response.setEndDate(med.getEndDate());
        response.setTreatmentDurationDays(med.getTreatmentDurationDays());
        response.setStockQuantity(med.getStockQuantity());
        response.setCurrentStock(med.getCurrentStock());
        response.setAcquisitionConfirmed(med.isAcquisitionConfirmed());
        response.setMedicationImage(med.getMedicationImage());
        response.setTreatmentStatus(med.getTreatmentStatus());
        response.setUserId(med.getUser().getId());
        response.setCreatedAt(med.getCreatedAt());
        response.setUpdatedAt(med.getUpdatedAt());
        return response;
    }
}