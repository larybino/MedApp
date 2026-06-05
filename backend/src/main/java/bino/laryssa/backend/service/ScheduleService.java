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

        if (request.getEndDate() != null) {
            schedule.setEndDate(request.getEndDate());
        } else if (request.getTreatmentDurationDays() > 0) {
            schedule.setEndDate(request.getStartDate().plusDays(request.getTreatmentDurationDays()));
        }

        Schedule saved = scheduleRepository.save(schedule);
        generateDosesPerPeriod(saved, LocalDate.now(), LocalDate.now().plusDays(7));
        return saved;
    }

    public Schedule update(Schedule schedule, MedicationRequest request) {
        schedule.setStartDate(request.getStartDate());
        schedule.setTreatmentDurationDays(request.getTreatmentDurationDays());

        if (request.getEndDate() != null) {
            schedule.setEndDate(request.getEndDate());
        } else if (request.getTreatmentDurationDays() > 0) {
            schedule.setEndDate(request.getStartDate().plusDays(request.getTreatmentDurationDays()));
        }
        return scheduleRepository.save(schedule);
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
        return scheduleDoseRepository.findBySchedule_Medication_UserIdAndScheduledDate(userId, date);
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
        LocalDate current = from;
        while (!current.isAfter(to)) {
            if (isDateInTreatment(schedule, current)) {
                generateDosesPerDay(schedule, current);
            }
            current = current.plusDays(1);
        }
    }

    private void generateDosesPerDay(Schedule schedule, LocalDate date) {
        if (scheduleDoseRepository.existsBySchedule_IdAndScheduledDate(schedule.getId(), date)) return;

        List<LocalTime> times = calculateDoseTimes(schedule.getMedication());

        List<ScheduleDose> doses = times.stream().map(time -> {
            ScheduleDose dose = new ScheduleDose();
            dose.setSchedule(schedule);
            dose.setScheduledDate(date);
            dose.setScheduledTime(time);
            return dose;
        }).toList();

        scheduleDoseRepository.saveAll(doses);
    }

    private List<LocalTime> calculateDoseTimes(Medication med) {
        if (med.getStartTime() == null || med.getDoseInterval() == null)
            return List.of();

        LocalTime start = med.getStartTime();
        List<LocalTime> times = new ArrayList<>();

        int intervalHours = switch (med.getDoseInterval()) {
            case FOUR_HOURS -> 4;
            case SIX_HOURS -> 6;
            case EIGHT_HOURS -> 8;
            case TWELVE_HOURS -> 12;
            case TWENTY_FOUR_HOURS -> 24;
            default -> 0;
        };

        if (intervalHours == 0) {
            times.add(start);
            return times;
        }

        LocalTime current = start;
        do {
            times.add(current);
            current = current.plusHours(intervalHours);
        } while (!current.equals(start) && times.size() < 24);

        return times;
    }

    private boolean isDateInTreatment(Schedule schedule, LocalDate date) {
        if (date.isBefore(schedule.getStartDate())) return false;
        if (schedule.getEndDate() != null &&
                date.isAfter(schedule.getEndDate())) return false;
        return true;
    }
}