package bino.laryssa.backend.model.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChangePasswordRequest {
    @NotBlank(message = "A senha antiga é obrigatória")
    private String oldPassword;
    @NotBlank(message = "A nova senha é obrigatória")
    private String newPassword;
}
