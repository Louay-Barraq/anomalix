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
public class DonneeErroneRule implements AnomalyRule {

    private final BullBordRepository bullBordRepository;
    private final DossierRepository dossierRepository;
    private final AnomalyRepository anomalyRepository;

    @Override
    public String getName() {
        return "DONNEE_ERRONEE";
    }

    @Override
    public List<Anomaly> detect() {
        List<Anomaly> anomalies = new ArrayList<>();

        List<BullBord> bloques = bullBordRepository.findByEtatIn(List.of("IS", "ES", "IV", "EV"));

        for (BullBord bull : bloques) {
            dossierRepository.findByNumero(bull.getNumDossier()).ifPresent(dossier -> {
                boolean adhesionIncorrecte = !bull.getAdhesion().equals(dossier.getAdhesion());
                boolean maladeInvalide = !List.of("adherent", "conjoint", "enfant")
                        .contains(dossier.getMalade());
                boolean dateNaissanceManquante = dossier.getDateNaissance() == null;

                if (adhesionIncorrecte || maladeInvalide || dateNaissanceManquante) {
                    if (!anomalyRepository.existsByNumDossier(bull.getNumDossier())) {
                        String detail = buildDetail(adhesionIncorrecte, maladeInvalide, dateNaissanceManquante);
                        anomalies.add(Anomaly.builder()
                                .numDossier(bull.getNumDossier())
                                .etatActuel(bull.getEtat())
                                .cause(getName())
                                .correction("Données incorrectes détectées : " + detail)
                                .dateDetection(LocalDate.now())
                                .build());
                    }
                }
            });
        }

        return anomalies;
    }

    private String buildDetail(boolean adhesion, boolean malade, boolean dateNaissance) {
        List<String> details = new ArrayList<>();
        if (adhesion) details.add("adhésion incohérente entre BullBord et Dossier");
        if (malade) details.add("valeur invalide pour le champ malade");
        if (dateNaissance) details.add("date de naissance manquante");
        return String.join(", ", details);
    }
}