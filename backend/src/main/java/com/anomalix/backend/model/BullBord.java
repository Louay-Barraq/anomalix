package com.anomalix.backend.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "BullBord")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class BullBord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 2)
    private String etat; // IS, ES, TS, IV, EV, TV

    @Column(name = "num_dossier", nullable = false, length = 20)
    private String numDossier;

    @Column(name = "[date]", nullable = false)
    private LocalDate date;

    @Column(nullable = false)
    private Integer contrat;

    @Column(nullable = false)
    private Long adhesion;
}