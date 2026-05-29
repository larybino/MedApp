package bino.laryssa.backend.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

import bino.laryssa.backend.model.enums.Gender;
import bino.laryssa.backend.model.enums.UserRole;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private String name;
    @Column(unique = true)
    private String email;
    private String password;
    private Gender gender;
    private LocalDate birthDate;
    private double weight;
    private String phone;
    @Column(columnDefinition = "LONGTEXT")
    private String profilePicture;
    private UserRole role;
    @Column(nullable = false)
    private boolean active = true;
    private String recoveryCode;
    private LocalDateTime recoveryCodeExpiration;
    @Column(unique = true)
    private String memberCode;
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        if (this.role == null) this.role = UserRole.MASTER;
        if (this.memberCode == null) {
            this.memberCode = "MED-" + UUID.randomUUID()
                .toString().substring(0, 8).toUpperCase();
    }
    }
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
