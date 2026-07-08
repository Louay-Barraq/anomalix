package com.anomalix.backend.repository;

import com.anomalix.backend.model.Anomaly;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AnomalyRepository extends JpaRepository<Anomaly, Integer> {

    List<Anomaly> findByCause(String cause);

    List<Anomaly> findByNumDossier(String numDossier);

    boolean existsByNumDossier(String numDossier);
}