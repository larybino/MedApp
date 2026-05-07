package bino.laryssa.backend.model.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

import bino.laryssa.backend.model.User;
import bino.laryssa.backend.model.enums.Gender;
import bino.laryssa.backend.model.enums.UserRole;
import lombok.Data;

@Data
public class UserResponse {
    private Long id;
    private String name;
    private String email;
    private LocalDate birthDate;
    private Gender gender;
    private String phone;
    private String association;
    private String profilePicture;
    private UserRole role;
    private Long masterId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;


    public static UserResponse toResponse(User user) {
        UserResponse response = new UserResponse();
        response.setId(user.getId());
        response.setName(user.getName());
        response.setEmail(user.getEmail());
        response.setBirthDate(user.getBirthDate());
        response.setGender(user.getGender());
        response.setPhone(user.getPhone());
        response.setAssociation(user.getAssociation());
        response.setProfilePicture(user.getProfilePicture());
        response.setRole(user.getRole());
        response.setMasterId(user.getMaster() != null ? user.getMaster().getId() : null);
        response.setCreatedAt(user.getCreatedAt());
        response.setUpdatedAt(user.getUpdatedAt());
        return response;
    }
}
