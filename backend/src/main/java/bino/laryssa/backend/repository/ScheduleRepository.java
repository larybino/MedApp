package bino.laryssa.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import bino.laryssa.backend.model.Schedule;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    Optional<Schedule> findByMedicationId(Long medicationId);
    List<Schedule> findByMedication_UserIdAndScheduleStatus(Long userId, String scheduleStatus);
    boolean existsByMedicationId(Long medicationId);
}
