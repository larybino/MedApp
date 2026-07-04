package bino.laryssa.backend.repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import bino.laryssa.backend.model.ScheduleDose;
import bino.laryssa.backend.model.enums.DoseStatus;

public interface ScheduleDoseRepository extends JpaRepository<ScheduleDose, Long> {
    List<ScheduleDose> findBySchedule_Medication_UserIdAndScheduledDate(Long userId, LocalDate date);
    List<ScheduleDose> findBySchedule_IdAndScheduledDate(Long scheduleId, LocalDate date);
    List<ScheduleDose> findBySchedule_IdAndDoseStatus(Long scheduleId, DoseStatus status);
    boolean existsBySchedule_IdAndScheduledDate(Long scheduleId, LocalDate date);
    boolean existsBySchedule_IdAndScheduledDateAndScheduledTime(Long scheduleId, LocalDate date, LocalTime time);
    List<ScheduleDose> findBySchedule_Medication_UserIdAndScheduledDateLessThanEqualAndDoseStatus(Long userId, LocalDate date, DoseStatus status);
    List<ScheduleDose> findByDoseStatus(DoseStatus doseStatus);
}
