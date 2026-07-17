package bino.laryssa.backend.model.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

@Data
public class RestockRequest {
    @NotNull(message = "A quantidade reposta é obrigatória")
    @Positive(message = "A quantidade reposta deve ser maior que zero")
    private Double quantity;
}