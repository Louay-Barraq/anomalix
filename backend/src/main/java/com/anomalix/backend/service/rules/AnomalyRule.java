package com.anomalix.backend.service.rules;

import com.anomalix.backend.model.Anomaly;
import java.util.List;

public interface AnomalyRule {
    List<Anomaly> detect();
    String getName();
}