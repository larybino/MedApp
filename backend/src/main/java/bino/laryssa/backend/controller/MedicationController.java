package bino.laryssa.backend.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import bino.laryssa.backend.model.dto.MedicationRequest;
import bino.laryssa.backend.model.dto.MedicationResponse;
import bino.laryssa.backend.service.MedicationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/medications")
@RequiredArgsConstructor
public class MedicationController {
    private final MedicationService medicationService;

    @PostMapping
    public ResponseEntity<MedicationResponse> create(@Valid @RequestBody MedicationRequest request) {
        return ResponseEntity.status(201).body(medicationService.create(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<MedicationResponse> getById(@PathVariable Long id) {
        return ResponseEntity.ok(medicationService.getById(id));
     }

    @PutMapping("/{id}")
    public ResponseEntity<MedicationResponse> update(@PathVariable Long id, @Valid @RequestBody MedicationRequest request) {
        return ResponseEntity.ok(medicationService.update(id, request));
     }

    @GetMapping
    public ResponseEntity<List<MedicationResponse>> getAll(@RequestParam Long userId) {
        return ResponseEntity.ok(medicationService.listByUser(userId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        medicationService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/confirm-acquisition")
    public ResponseEntity<MedicationResponse> confirmAcquisition(@PathVariable Long id) {
        return ResponseEntity.ok(medicationService.confirmAcquisition(id));
    }

    @PutMapping("/{id}/end-treatment")
    public ResponseEntity<MedicationResponse> endTreatment(@PathVariable Long id) {
        return ResponseEntity.ok(medicationService.endTreatment(id));
    }
}
