package bino.laryssa.backend.model.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ResetPasswordRequest {
    @NotBlank(message = "O token é obrigatório")
    private String token;
    @NotBlank(message = "A nova senha é obrigatória")
    private String newPassword;
    @NotBlank(message = "A confirmação da nova senha é obrigatória")
    private String confirmNewPassword;
}
