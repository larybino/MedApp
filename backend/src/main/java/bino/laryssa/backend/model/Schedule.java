package bino.laryssa.backend.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import bino.laryssa.backend.model.enums.ScheduleStatus;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "schedules")
@Data
public class Schedule {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private LocalDate startDate;
    private LocalDate endDate;
    private int treatmentDurationDays;
    @OneToOne
    @JoinColumn(name = "medication_id", nullable = false)
    private Medication medication;
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private ScheduleStatus scheduleStatus;
    @OneToMany(mappedBy = "schedule", cascade = CascadeType.ALL)
    private List<ScheduleDose> scheduleDoses;
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (scheduleStatus == null) scheduleStatus = ScheduleStatus.ACTIVE;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
