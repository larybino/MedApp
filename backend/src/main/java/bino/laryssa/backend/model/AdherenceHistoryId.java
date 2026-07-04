package bino.laryssa.backend.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDate;

@Embeddable
@Data
public class AdherenceHistoryId implements Serializable {

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "date")
    private LocalDate date;
}