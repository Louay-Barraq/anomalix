package com.anomalix.backend.service.rules;

import com.anomalix.backend.model.Anomaly;
import com.anomalix.backend.model.BullBord;
import com.anomalix.backend.repository.AnomalyRepository;
import com.anomalix.backend.repository.BullBordRepository;
import com.anomalix.backend.repository.DossierRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Component
@RequiredArgsConstructor
public class MigrationErrorRule implements AnomalyRule {

    private final BullBordRepository bullBordRepository;
    private final DossierRepository dossierRepository;
    private final AnomalyRepository anomalyRepository;

    @Override
    public String getName() {
        return "ERREUR_MIGRATION";
    }

    @Override
    public List<Anomaly> detect() {
        List<Anomaly> anomalies = new ArrayList<>();

        List<BullBord> bloques = bullBordRepository.findByEtatIn(List.of("IS", "ES", "IV", "EV"));

        for (BullBord bull : bloques) {
            // Anomalie de migration : BullBord existe mais aucun Dossier correspondant
            boolean dossierAbsent = dossierRepository.findByNumero(bull.getNumDossier()).isEmpty();

            if (dossierAbsent) {
                if (!anomalyRepository.existsByNumDossier(bull.getNumDossier())) {
                    anomalies.add(Anomaly.builder()
                            .numDossier(bull.getNumDossier())
                            .etatActuel(bull.getEtat())
                            .cause(getName())
                            .correction("Dossier " + bull.getNumDossier() +
                                    " introuvable — réimporter depuis le système source")
                            .dateDetection(LocalDate.now())
                            .build());
                }
            }
        }

        return anomalies;
    }
}