package bino.laryssa.backend.model.dto;

import bino.laryssa.backend.model.Medication;
import bino.laryssa.backend.model.enums.DoseInterval;
import bino.laryssa.backend.model.enums.ScheduleStatus;
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
    private Double doseAmount;
    private String doseUnit;

    private String activeIngredients;
    private String pharmaceuticalForm;
    private String administrationRoute;
    private LocalTime startTime;

    private Long scheduleId;
    private LocalDate startDate;
    private LocalDate endDate;
    private int treatmentDurationDays;
    private ScheduleStatus scheduleStatus;

    private int stockQuantity;
    private int currentStock;
    private boolean acquisitionConfirmed;
    private String medicationImage;
    private Long userId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static MedicationResponse toResponse(Medication med) {
        MedicationResponse response = new MedicationResponse();
        response.setId(med.getId());
        response.setName(med.getName());
        response.setDosage(med.getDosage());
        response.setDoseInterval(med.getDoseInterval());
        response.setDoseAmount(med.getDoseAmount());
        response.setDoseUnit(med.getDoseUnit());
        response.setActiveIngredients(med.getActiveIngredients());
        response.setPharmaceuticalForm(med.getPharmaceuticalForm());
        response.setAdministrationRoute(med.getAdministrationRoute());
        response.setStartTime(med.getStartTime());
        response.setStockQuantity(med.getStockQuantity());
        response.setCurrentStock(med.getCurrentStock());
        response.setAcquisitionConfirmed(med.isAcquisitionConfirmed());
        response.setMedicationImage(med.getMedicationImage());
        response.setUserId(med.getUser().getId());
        response.setCreatedAt(med.getCreatedAt());
        response.setUpdatedAt(med.getUpdatedAt());

        
        if (med.getSchedule() != null) {
            response.setScheduleId(med.getSchedule().getId());
            response.setStartDate(med.getSchedule().getStartDate());
            response.setEndDate(med.getSchedule().getEndDate());
            response.setTreatmentDurationDays(med.getSchedule().getTreatmentDurationDays());
            response.setScheduleStatus(med.getSchedule().getScheduleStatus());
        }
        return response;
    }
}