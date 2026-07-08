package com.anomalix.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class AnomalixBackendApplication {
	public static void main(String[] args) {
		SpringApplication.run(AnomalixBackendApplication.class, args);
	}

}
