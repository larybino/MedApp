package bino.laryssa.backend.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CreateMemberRequest {
    @NotBlank
    private String mode;
    private String name;
    @Email(message = "O email deve ser válido")
    private String email;
    private String password;
    private String memberCode;
}
