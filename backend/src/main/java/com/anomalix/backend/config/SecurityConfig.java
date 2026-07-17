package com.anomalix.backend.config;

import com.anomalix.backend.security.JwtFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtFilter jwtFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // Endpoints publics
                        .requestMatchers("/api/auth/login").permitAll()
                        // Bulletin de famille consultable depuis l'espace adhérent
                        .requestMatchers("/api/bullbord/famille").hasRole("ADHERENT")
                        // Endpoints admin seulement
                        .requestMatchers("/api/anomalies/**").hasRole("ADMIN")
                        .requestMatchers("/api/bullbord/**").hasRole("ADMIN")
                        // Endpoints adhérent seulement
                        .requestMatchers("/api/bulletins/**").hasRole("ADHERENT")
                        // Endpoints communs aux deux
                        .requestMatchers("/api/dossiers/**").authenticated()
                        .requestMatchers("/api/auth/switch-role").authenticated()
                        // Tout le reste requiert une authentification
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}