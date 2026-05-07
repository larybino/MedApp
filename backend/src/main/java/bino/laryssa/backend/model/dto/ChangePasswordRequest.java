package bino.laryssa.backend.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ChangePasswordRequest {
    @NotBlank(message = "O email é obrigatório")
    @Email(message = "O email deve ser válido")
    private String email;
    @NotBlank(message = "A senha antiga é obrigatória")
    private String oldPassword;
    @NotBlank(message = "A nova senha é obrigatória")
    private String newPassword;
}
