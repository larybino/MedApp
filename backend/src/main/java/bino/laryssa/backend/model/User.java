package bino.laryssa.backend.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import bino.laryssa.backend.model.enums.Gender;
import bino.laryssa.backend.model.enums.UserRole;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
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
    @Column(nullable = false, unique = true)
    private String email;
    @Column(nullable = false)
    private String password;
    private Gender gender;
    private LocalDate birthDate;
    private String phone;
    private String association;
    @Column(columnDefinition = "LONGTEXT")
    private String profilePicture;
    private UserRole role;
    @ManyToOne
    @JoinColumn(name = "master_id")
    private User master;
    @OneToMany(mappedBy = "master", cascade = CascadeType.ALL)
    private List<User> members;
    @Column(nullable = false)
    private boolean active = true;
    private String recoveryCode;
    private LocalDateTime recoveryCodeExpiration;
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        if (this.role == null) this.role = UserRole.MASTER;
    }
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
