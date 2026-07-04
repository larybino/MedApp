package bino.laryssa.backend.model;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.Immutable;


@Entity
@Immutable
@Table(name = "adherence_history")
@Data
public class AdherenceHistory {

    @EmbeddedId
    private AdherenceHistoryId id;

    @Column(name = "total_doses")
    private int totalDoses;

    @Column(name = "taken_doses")
    private int takenDoses;

    @Column(name = "missed_doses")
    private int missedDoses;

    @Column(name = "delayed_doses")
    private int delayedDoses;

    @Column(name = "adherence_rate")
    private double adherenceRate;
}