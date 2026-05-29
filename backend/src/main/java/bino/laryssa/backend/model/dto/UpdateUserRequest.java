package bino.laryssa.backend.model.dto;

import java.time.LocalDate;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateUserRequest {
    @NotBlank(message = "O nome é obrigatório")
    private String name;
    private String email;
    private LocalDate birthDate;
    private double weight;
    private String gender;
    private String phone;
    private String profilePicture;

}
