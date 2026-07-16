package bino.laryssa.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import bino.laryssa.backend.model.Medication;
import bino.laryssa.backend.model.enums.ScheduleStatus;

public interface MedicationRepository extends JpaRepository<Medication, Long> {
    List<Medication> findByUserIdAndSchedule_ScheduleStatusNotAndActiveTrue(Long userId, ScheduleStatus scheduleStatus);
    List<Medication> findByUserIdAndSchedule_ScheduleStatus(Long userId, ScheduleStatus scheduleStatus);
    Optional<Medication> findByIdAndUserId(Long id, Long userId);
    List<Medication> findByUserIdAndCurrentStockLessThanEqual(Long userId, Integer currentStock);
    List<Medication> findByUserIdAndScheduleIsNullAndActiveTrue(Long userId);
}
