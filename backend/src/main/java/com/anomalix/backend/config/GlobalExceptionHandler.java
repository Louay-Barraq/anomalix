package com.anomalix.backend.config;

import jakarta.persistence.EntityNotFoundException;
import org.springframework.dao.DataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // Erreurs de validation (@Valid)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidation(
            MethodArgumentNotValidException ex) {

        Map<String, String> fieldErrors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String field = ((FieldError) error).getField();
            String message = error.getDefaultMessage();
            fieldErrors.put(field, message);
        });

        return ResponseEntity.badRequest().body(Map.of(
                "error", "Validation échouée",
                "details", fieldErrors
        ));
    }

    // Ressource introuvable
    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<Map<String, String>> handleNotFound(
            EntityNotFoundException ex) {
        return ResponseEntity.status(404)
                .body(Map.of("error", ex.getMessage()));
    }

    // Erreur BDD
    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<Map<String, String>> handleDatabase(
            DataAccessException ex) {
        return ResponseEntity.status(500)
                .body(Map.of("error", "Erreur base de données : " + ex.getMessage()));
    }

    // Toute autre erreur
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleGeneric(Exception ex) {
        return ResponseEntity.status(500)
                .body(Map.of("error", "Erreur interne : " + ex.getMessage()));
    }
}