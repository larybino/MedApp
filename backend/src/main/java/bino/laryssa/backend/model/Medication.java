package bino.laryssa.backend.model;

import java.time.LocalDateTime;
import java.time.LocalTime;

import bino.laryssa.backend.model.enums.DoseInterval;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "medications")
public class Medication  {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private String name;
    @Column(nullable = false)
    private String dosage;
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private DoseInterval doseInterval;
    @Column(nullable = false)
    private Double doseAmount;
    @Column(nullable = false)
    private String doseUnit;
    @Column(columnDefinition = "LONGTEXT")
    private String medicationImage;
    private boolean acquisitionConfirmed = false;
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    @Column(nullable = false)
    private LocalDateTime updatedAt;
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String activeIngredients;
    private String administrationRoute;
    private String pharmaceuticalForm;

    @OneToOne(mappedBy = "medication", cascade = CascadeType.ALL)
    private Schedule schedule;
    private LocalTime startTime;
    @Column(nullable = false)
    private Double stockQuantity;
    private Double currentStock;

    @Column(nullable = false)
    private boolean active = true;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
}
