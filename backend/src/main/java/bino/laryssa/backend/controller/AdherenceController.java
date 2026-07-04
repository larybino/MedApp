package bino.laryssa.backend.controller;

import bino.laryssa.backend.model.dto.AdherenceHistoryResponse;
import bino.laryssa.backend.service.AdherenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/adherence")
@RequiredArgsConstructor
public class AdherenceController {

    private final AdherenceService adherenceService;

    @GetMapping
    public ResponseEntity<List<AdherenceHistoryResponse>> getLast30Days(@RequestParam Long userId) {
        return ResponseEntity.ok(adherenceService.getLast30Days(userId));
    }

    @GetMapping("/period")
    public ResponseEntity<List<AdherenceHistoryResponse>> getByPeriod(
            @RequestParam Long userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
                    LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
                    LocalDate endDate) {
        return ResponseEntity.ok(
                adherenceService.getByPeriod(userId, startDate, endDate));
    }
}