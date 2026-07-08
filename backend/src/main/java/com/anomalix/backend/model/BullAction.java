package com.anomalix.backend.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "BullAction")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class BullAction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 2)
    private String etat; // TS, EV, TV

    @Column(name = "id_etat", nullable = false)
    private Integer idEtat; // 3, 5, 6

    @Column(name = "num_dossier", nullable = false, length = 20)
    private String numDossier;
}