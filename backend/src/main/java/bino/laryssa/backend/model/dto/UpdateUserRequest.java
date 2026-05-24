package bino.laryssa.backend.model.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class UpdateUserRequest {
    private String name;
    private String email;
    private LocalDate birthDate;
    private double weight;
    private String gender;
    private String phone;
    private String association;
    private String profilePicture;

}
