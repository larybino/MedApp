package bino.laryssa.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import bino.laryssa.backend.model.Schedule;
import bino.laryssa.backend.model.enums.ScheduleStatus;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    Optional<Schedule> findByMedicationId(Long medicationId);
    List<Schedule> findByMedication_UserIdAndScheduleStatus(Long userId, ScheduleStatus scheduleStatus);
    boolean existsByMedicationId(Long medicationId);
}
