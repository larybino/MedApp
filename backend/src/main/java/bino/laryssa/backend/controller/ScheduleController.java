package bino.laryssa.backend.controller;

import bino.laryssa.backend.model.ScheduleDose;
import bino.laryssa.backend.model.dto.ScheduleDoseResponse;
import bino.laryssa.backend.service.ScheduleService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/schedule")
@RequiredArgsConstructor
public class ScheduleController {

    private final ScheduleService scheduleService;

    @GetMapping("/today")
    public ResponseEntity<List<ScheduleDoseResponse>> getDosesToday(@RequestParam Long userId) {
        List<ScheduleDose> doses = scheduleService.getDosesPerDay(userId, LocalDate.now());
        return ResponseEntity.ok(doses.stream().map(ScheduleDoseResponse::toResponse).toList());
    }

    @GetMapping("/doses")
    public ResponseEntity<List<ScheduleDoseResponse>> getDosesByDate(@RequestParam Long userId, @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        List<ScheduleDose> doses = scheduleService.getDosesPerDay(userId, date);
        return ResponseEntity.ok(doses.stream().map(ScheduleDoseResponse::toResponse).toList());
    }

    @PutMapping("/doses/{id}/confirm")
    public ResponseEntity<ScheduleDoseResponse> confirmDose(@PathVariable Long id) {
        ScheduleDose dose = scheduleService.confirmDose(id);
        return ResponseEntity.ok(ScheduleDoseResponse.toResponse(dose));
    }
}