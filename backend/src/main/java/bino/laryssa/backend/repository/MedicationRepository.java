package bino.laryssa.backend.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import bino.laryssa.backend.model.Medication;
import bino.laryssa.backend.model.enums.TreatmentStatus;

public interface MedicationRepository extends JpaRepository<Medication, Long> {
    List<Medication> findByUserIdAndTreatmentStatusNot(Long userId, TreatmentStatus treatmentStatus);
    List<Medication> findByUserIdAndTreatmentStatus(Long userId, TreatmentStatus treatmentStatus);
    Optional<Medication> findByIdAndUserId(Long id, Long userId);
    List<Medication> findByStartDateAndTreatmentStatus(LocalDate startDate, TreatmentStatus treatmentStatus);
    List<Medication> findByUserIdAndTreatmentStatusAndCurrentStockLessThanEqual(
            Long userId, TreatmentStatus treatmentStatus, Integer currentStock);
}
