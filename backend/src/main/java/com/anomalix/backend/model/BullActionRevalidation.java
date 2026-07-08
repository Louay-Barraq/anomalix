package com.anomalix.backend.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "BullActionRevalidation")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class BullActionRevalidation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 2)
    private String etat; // IR, ER, TR

    @Column(name = "id_etat", nullable = false)
    private Integer idEtat; // 7, 8, 9

    @Column(name = "num_dossier", nullable = false, length = 20)
    private String numDossier;
}