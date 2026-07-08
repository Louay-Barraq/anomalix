package com.anomalix.backend.dto;

import com.anomalix.backend.model.Anomaly;
import lombok.*;
import java.time.LocalDate;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class AnomalyResponse {

    private Integer id;
    private String numDossier;
    private String etatActuel;
    private String cause;
    private String correction;
    private LocalDate dateDetection;

    public static AnomalyResponse fromEntity(Anomaly anomaly) {
        return AnomalyResponse.builder()
                .id(anomaly.getId())
                .numDossier(anomaly.getNumDossier())
                .etatActuel(anomaly.getEtatActuel())
                .cause(anomaly.getCause())
                .correction(anomaly.getCorrection())
                .dateDetection(anomaly.getDateDetection())
                .build();
    }
}