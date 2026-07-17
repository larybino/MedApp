package bino.laryssa.backend.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import bino.laryssa.backend.model.enums.DoseStatus;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Data
@Table(name = "schedule_doses")
public class ScheduleDose {
    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    @JoinColumn(name = "schedule_id", nullable = false)
    private Schedule schedule;
    @Column(nullable = false)
    private LocalDate scheduledDate; 
    @Column(nullable = false)
    private LocalTime scheduledTime; 
    private LocalDateTime confirmedAt;
    @Column(nullable = false)
    private int confirmationWindowMinutes = 120;
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private DoseStatus doseStatus;
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (doseStatus == null) doseStatus = DoseStatus.PENDING;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public boolean isWithinConfirmationWindow() {
        LocalDateTime scheduled = LocalDateTime.of(scheduledDate, scheduledTime);
        LocalDateTime windowStart = scheduled.minusMinutes(confirmationWindowMinutes);
        LocalDateTime windowEnd = scheduled.plusMinutes(confirmationWindowMinutes);
        LocalDateTime now = LocalDateTime.now();
        return !now.isBefore(windowStart) && now.isBefore(windowEnd);
    }
}