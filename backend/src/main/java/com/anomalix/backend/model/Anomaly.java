package com.anomalix.backend.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "Anomaly")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class Anomaly {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "num_dossier", nullable = false, length = 20)
    private String numDossier;

    @Column(name = "etat_actuel", nullable = false, length = 2)
    private String etatActuel;

    @Column(nullable = false, length = 100)
    private String cause;

    @Column(nullable = false, length = 500)
    private String correction;

    @Column(name = "date_detection", nullable = false)
    private LocalDate dateDetection;
}