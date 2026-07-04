package bino.laryssa.backend.service;

import bino.laryssa.backend.model.dto.AdherenceHistoryResponse;
import bino.laryssa.backend.repository.AdherenceHistoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdherenceService {

    private final AdherenceHistoryRepository adherenceHistoryRepository;

    public List<AdherenceHistoryResponse> getLast30Days(Long userId) {
        LocalDate start = LocalDate.now().minusDays(29);
        return adherenceHistoryRepository
                .findByIdUserIdAndIdDateGreaterThanEqualOrderByIdDateDesc(userId, start)
                .stream()
                .map(h -> {
                    AdherenceHistoryResponse r = new AdherenceHistoryResponse();
                    r.setDate(h.getId().getDate());
                    r.setTotalDoses(h.getTotalDoses());
                    r.setTakenDoses(h.getTakenDoses());
                    r.setMissedDoses(h.getMissedDoses());
                    r.setDelayedDoses(h.getDelayedDoses());
                    r.setAdherenceRate(h.getAdherenceRate());
                    return r;
                })
                .toList();
    }

    public List<AdherenceHistoryResponse> getByPeriod(Long userId, LocalDate start, LocalDate end) {
        return adherenceHistoryRepository
                .findByIdUserIdAndIdDateBetweenOrderByIdDateDesc(userId, start, end)
                .stream()
                .map(h -> {
                    AdherenceHistoryResponse r = new AdherenceHistoryResponse();
                    r.setDate(h.getId().getDate());
                    r.setTotalDoses(h.getTotalDoses());
                    r.setTakenDoses(h.getTakenDoses());
                    r.setMissedDoses(h.getMissedDoses());
                    r.setDelayedDoses(h.getDelayedDoses());
                    r.setAdherenceRate(h.getAdherenceRate());
                    return r;
                })
                .toList();
    }
}