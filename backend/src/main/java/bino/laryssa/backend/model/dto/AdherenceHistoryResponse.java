package bino.laryssa.backend.model.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class AdherenceHistoryResponse {
    private LocalDate date;
    private int totalDoses;
    private int takenDoses;
    private int missedDoses;
    private int delayedDoses;
    private double adherenceRate;
}