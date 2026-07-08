package com.anomalix.backend.scheduler;

import com.anomalix.backend.service.AnomalyService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class AnomalyScheduler {

    private final AnomalyService anomalyService;


    // @Scheduled(fixedRate = 30 * 60 * 1000)     // Toutes les 30 minutes
    // @Scheduled(fixedRate = 60 * 1000)          // toutes les minutes
    // @Scheduled(fixedRate = 5 * 60 * 1000)      // toutes les 5 minutes
    // @Scheduled(fixedRate = 60 * 60 * 1000)     // toutes les heures
    @Scheduled(cron = "0 0 8 * * MON-FRI")     // tous les jours à 8h du matin
    // @Scheduled(fixedRateString = "${anomalix.scheduler.rate}")
    public void runDetection() {
        log.info("Scheduled detection started...");
        try {
            var detected = anomalyService.detectAndSave();
            log.info("Scheduled detection complete — {} new anomalies saved.",
                    detected.size());
        } catch (Exception e) {
            log.error("Scheduled detection failed : {}", e.getMessage());
        }
    }
}