package bino.laryssa.backend.repository;

import bino.laryssa.backend.model.AdherenceHistory;
import bino.laryssa.backend.model.AdherenceHistoryId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface AdherenceHistoryRepository extends JpaRepository<AdherenceHistory, AdherenceHistoryId> {

    List<AdherenceHistory> findByIdUserIdAndIdDateGreaterThanEqualOrderByIdDateDesc(
            Long userId, LocalDate startDate);

    List<AdherenceHistory> findByIdUserIdAndIdDateBetweenOrderByIdDateDesc(
            Long userId, LocalDate startDate, LocalDate endDate);
}