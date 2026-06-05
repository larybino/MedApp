package bino.laryssa.backend.model.dto;

import bino.laryssa.backend.model.ScheduleDose;
import bino.laryssa.backend.model.enums.DoseStatus;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
public class ScheduleDoseResponse {
    private Long id;
    private Long scheduleId;
    private Long medicationId;
    private String medicationName;
    private String dosage;
    private String medicationImage;
    private LocalDate scheduledDate;
    private LocalTime scheduledTime;
    private LocalDateTime confirmedAt;
    private int confirmationWindowMinutes;
    private DoseStatus doseStatus;
    private boolean withinWindow;

    public static ScheduleDoseResponse toResponse(ScheduleDose dose) {
        ScheduleDoseResponse response = new ScheduleDoseResponse();
        response.setId(dose.getId());
        response.setScheduleId(dose.getSchedule().getId());
        response.setMedicationId(dose.getSchedule().getMedication().getId());
        response.setMedicationName(dose.getSchedule().getMedication().getName());
        response.setDosage(dose.getSchedule().getMedication().getDosage());
        response.setMedicationImage(dose.getSchedule().getMedication().getMedicationImage());
        response.setScheduledDate(dose.getScheduledDate());
        response.setScheduledTime(dose.getScheduledTime());
        response.setConfirmedAt(dose.getConfirmedAt());
        response.setConfirmationWindowMinutes(dose.getConfirmationWindowMinutes());
        response.setDoseStatus(dose.getDoseStatus());
        response.setWithinWindow(dose.isWithinConfirmationWindow());
        return response;
    }
}