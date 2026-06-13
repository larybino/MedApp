package bino.laryssa.backend.service;

import bino.laryssa.backend.exception.NotFoundException;
import bino.laryssa.backend.model.Medication;
import bino.laryssa.backend.model.Schedule;
import bino.laryssa.backend.model.ScheduleDose;
import bino.laryssa.backend.model.dto.MedicationRequest;
import bino.laryssa.backend.model.enums.DoseStatus;
import bino.laryssa.backend.model.enums.ScheduleStatus;
import bino.laryssa.backend.repository.ScheduleDoseRepository;
import bino.laryssa.backend.repository.ScheduleRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final ScheduleDoseRepository scheduleDoseRepository;

    public Schedule create(Medication medication, MedicationRequest request) {
        if (scheduleRepository.existsByMedicationId(medication.getId()))
            throw new IllegalArgumentException("Já existe um agendamento para este medicamento");

        Schedule schedule = new Schedule();
        schedule.setMedication(medication);
        schedule.setStartDate(request.getStartDate());
        schedule.setTreatmentDurationDays(request.getTreatmentDurationDays());

        if (request.getTreatmentDurationDays() > 0) {
            schedule.setEndDate(request.getStartDate().plusDays(request.getTreatmentDurationDays()));
        } else if (request.getEndDate() != null) {
            schedule.setEndDate(request.getEndDate());
        } else {
            schedule.setEndDate(null);
        }

        Schedule saved = scheduleRepository.save(schedule);
        generateDosesPerPeriod(saved, LocalDate.now(), LocalDate.now().plusDays(7));
        return saved;
    }

    public Schedule update(Schedule schedule, MedicationRequest request) {
        schedule.setStartDate(request.getStartDate());
        schedule.setTreatmentDurationDays(request.getTreatmentDurationDays());

        if (request.getTreatmentDurationDays() > 0) {
            schedule.setEndDate(request.getStartDate().plusDays(request.getTreatmentDurationDays()));
        } else if (request.getEndDate() != null) {
            schedule.setEndDate(request.getEndDate());
        } else {
            schedule.setEndDate(null);
        }

        Schedule updatedSchedule = scheduleRepository.save(schedule);
        clearPendingDoses(updatedSchedule);
        generateDosesPerPeriod(updatedSchedule, LocalDate.now(), LocalDate.now().plusDays(7));

        return updatedSchedule;
    }

    public void finish(Schedule schedule) {
        schedule.setScheduleStatus(ScheduleStatus.FINISHED);
        schedule.setEndDate(LocalDate.now());
        scheduleRepository.save(schedule);
    }

    public void cancel(Schedule schedule) {
        schedule.setScheduleStatus(ScheduleStatus.CANCELLED);
        scheduleRepository.save(schedule);
    }

    public List<ScheduleDose> getDosesPerDay(Long userId, LocalDate date) {
        return scheduleDoseRepository.findBySchedule_Medication_UserIdAndScheduledDate(userId, date)
            .stream()
            .filter(dose -> dose.getSchedule().getScheduleStatus() != ScheduleStatus.CANCELLED)
            .toList();
    }

    public ScheduleDose confirmDose(Long doseId) {
        ScheduleDose dose = scheduleDoseRepository.findById(doseId).orElseThrow(() -> new NotFoundException("Dose não encontrada"));

        if (dose.getDoseStatus() != DoseStatus.PENDING)
            throw new IllegalArgumentException("Esta dose já foi processada: " + dose.getDoseStatus());
        dose.setDoseStatus(dose.isWithinConfirmationWindow()? DoseStatus.TAKEN: DoseStatus.DELAYED);
        dose.setConfirmedAt(LocalDateTime.now());
        return scheduleDoseRepository.save(dose);
    }

    private void generateDosesPerPeriod(Schedule schedule, LocalDate from, LocalDate to) {
        if (schedule.getMedication() == null || schedule.getMedication().getStartTime() == null) {
            return;
        }

        LocalDateTime currentDose = schedule.getStartDate().atTime(schedule.getMedication().getStartTime());
        LocalDateTime treatmentEnd;

        if (schedule.getTreatmentDurationDays() > 0) {
            treatmentEnd = currentDose.plusDays(schedule.getTreatmentDurationDays());
        } else if (schedule.getEndDate() != null) {
            treatmentEnd = schedule.getEndDate().atTime(LocalTime.MAX);
        } else {
            treatmentEnd = to.atTime(LocalTime.MAX);
        }

        LocalDateTime windowEnd = to.atTime(LocalTime.MAX);
        LocalDateTime limit = treatmentEnd.isBefore(windowEnd) ? treatmentEnd : windowEnd;

        int intervalHours = getIntervalHours(schedule.getMedication());
        List<ScheduleDose> dosesToSave = new ArrayList<>();

        while (currentDose.isBefore(limit)) {
            if (!currentDose.toLocalDate().isBefore(from)) {
                LocalDate doseDate = currentDose.toLocalDate();
                LocalTime doseTime = currentDose.toLocalTime();

                if (!scheduleDoseRepository.existsBySchedule_IdAndScheduledDateAndScheduledTime(
                        schedule.getId(), doseDate, doseTime)) {

                    ScheduleDose dose = new ScheduleDose();
                    dose.setSchedule(schedule);
                    dose.setScheduledDate(doseDate);
                    dose.setScheduledTime(doseTime);
                    dosesToSave.add(dose);
                }
            }
            
            if (intervalHours == 0) {
                currentDose = currentDose.plusDays(1);
            } else {
                currentDose = currentDose.plusHours(intervalHours);
            }
        }

        if (!dosesToSave.isEmpty()) {
            scheduleDoseRepository.saveAll(dosesToSave);
        }
    }

    private int getIntervalHours(Medication med) {
        if (med.getDoseInterval() == null) return 0;
        return switch (med.getDoseInterval()) {
            case FOUR_HOURS -> 4;
            case SIX_HOURS -> 6;
            case EIGHT_HOURS -> 8;
            case TWELVE_HOURS -> 12;
            case TWENTY_FOUR_HOURS -> 24;
            default -> 0;
        };
    }

    private void clearPendingDoses(Schedule schedule) {
        List<ScheduleDose> pendingDoses = scheduleDoseRepository.findBySchedule_IdAndDoseStatus(schedule.getId(), DoseStatus.PENDING);
        
        if (!pendingDoses.isEmpty()) {
            scheduleDoseRepository.deleteAll(pendingDoses);
        }
    }

    @Scheduled(fixedRate = 1800000)
    public void markMissedDoses() {
        LocalDateTime now = LocalDateTime.now();

        List<ScheduleDose> pendingDoses = scheduleDoseRepository.findByDoseStatus(DoseStatus.PENDING);

        List<ScheduleDose> toMiss = pendingDoses.stream()
                .filter(dose -> {
                    LocalDateTime scheduled = LocalDateTime.of(
                            dose.getScheduledDate(),
                            dose.getScheduledTime());
                    LocalDateTime windowEnd = scheduled.plusMinutes(
                            dose.getConfirmationWindowMinutes());
                    return now.isAfter(windowEnd);
                })
                .toList();

        if (!toMiss.isEmpty()) {
            toMiss.forEach(dose -> dose.setDoseStatus(DoseStatus.MISSED));
            scheduleDoseRepository.saveAll(toMiss);
        }
    }
    }