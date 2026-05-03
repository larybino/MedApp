package bino.laryssa.backend.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RegisterRequest {
    @NotBlank(message = "O nome é obrigatório")
    private String name;
    @NotBlank(message = "O email é obrigatório")
    @Email(message = "O email deve ser válido")
    private String email;
    @NotBlank(message = "A senha é obrigatória")
    private String password;
    @NotBlank(message = "A confirmação da senha é obrigatória")
    private String confirmPassword;
}
