package bino.laryssa.backend.model.dto;

import lombok.Data;

import java.util.List;

@Data
public class ExtractedMedicationsResponse {
    private List<ExtractedMedicationDTO> medications;
}