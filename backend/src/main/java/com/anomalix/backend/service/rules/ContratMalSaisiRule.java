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
public class ContratMalSaisiRule implements AnomalyRule {

    private final BullBordRepository bullBordRepository;
    private final DossierRepository dossierRepository;
    private final AnomalyRepository anomalyRepository;

    @Override
    public String getName() {
        return "CONTRAT_MAL_SAISI";
    }

    @Override
    public List<Anomaly> detect() {
        List<Anomaly> anomalies = new ArrayList<>();

        // Récupère tous les bulletins bloqués
        List<BullBord> bloques = bullBordRepository.findByEtatIn(List.of("IS", "ES", "IV", "EV"));

        for (BullBord bull : bloques) {
            // Vérifie que le contrat dans BullBord correspond à celui dans Dossier
            dossierRepository.findByNumero(bull.getNumDossier()).ifPresent(dossier -> {
                if (!bull.getContrat().equals(dossier.getContrat())) {
                    // Anomalie seulement si pas déjà détectée
                    if (!anomalyRepository.existsByNumDossier(bull.getNumDossier())) {
                        anomalies.add(Anomaly.builder()
                                .numDossier(bull.getNumDossier())
                                .etatActuel(bull.getEtat())
                                .cause(getName())
                                .correction("Vérifier le code contrat dans la table Dossier " +
                                        "— BullBord contrat: " + bull.getContrat() +
                                        ", Dossier contrat: " + dossier.getContrat())
                                .dateDetection(LocalDate.now())
                                .build());
                    }
                }
            });
        }

        return anomalies;
    }
}