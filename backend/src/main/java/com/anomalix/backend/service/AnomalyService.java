package com.anomalix.backend.service;

import com.anomalix.backend.model.Anomaly;
import com.anomalix.backend.repository.AnomalyRepository;
import com.anomalix.backend.service.rules.AnomalyRule;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AnomalyService {

    private final List<AnomalyRule> rules;
    private final AnomalyRepository anomalyRepository;

    // Lance toutes les règles et sauvegarde les nouvelles anomalies détectées
    @Transactional
    public List<Anomaly> detectAndSave() {
        List<Anomaly> allDetected = rules.stream()
                .flatMap(rule -> rule.detect().stream())
                .toList();

        return anomalyRepository.saveAll(allDetected);
    }

    // Retourne toutes les anomalies déjà en base
    @Transactional(readOnly = true)
    public List<Anomaly> getAllAnomalies() {
        return anomalyRepository.findAll();
    }

    // Retourne les anomalies d'un dossier spécifique
    @Transactional(readOnly = true)
    public List<Anomaly> getAnomaliesByDossier(String numDossier) {
        return anomalyRepository.findByNumDossier(numDossier);
    }
}