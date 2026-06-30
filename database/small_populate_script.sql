-- ============================================
-- Script 3 : Population légère de la BD
-- ============================================

USE MaghrebiaAnomalyDB;
GO

-- ============================================
-- DOSSIERS (5 dossiers)
-- ============================================
INSERT INTO Dossier (numero, contrat, adhesion, nom, prenom, adresse, emploi, malade, date_naissance)
VALUES
  ('N00034', 1013, 200034, 'Ayari',   'Sami',   'Tunis',  'Chirurgien', 'adherent', '1971-04-10'),
  ('N00035', 1013, 200035, 'Ayari',   'Nihel',  'Tunis',  'Chirurgien', 'conjoint', '1973-08-30'),
  ('N00036', 1014, 200036, 'Derbel',  'Fares',  'Sfax',   'Notaire',   'adherent', '1980-12-05'),
  ('N00037', 1014, 200037, 'Derbel',  'Cyrine', 'Sfax',   'Notaire',   'conjoint', '1982-06-18'),
  ('N00038', 1015, 200038, 'Nasri',   'Bilel',  'Sousse', 'Pilote',    'adherent', '1985-02-22');
GO

-- ============================================
-- BULLBORD
-- ============================================
INSERT INTO BullBord (etat, num_dossier, date, contrat, adhesion)
VALUES
  ('TV', 'N00034', '2025-03-01', 1013, 200034),  -- traité normalement
  ('IS', 'N00035', '2025-03-02', 1013, 200035),  -- bloqué en saisie
  ('EV', 'N00036', '2025-03-03', 1014, 200036),  -- bloqué en validation
  ('IS', 'N00037', '2025-03-04', 1014, 200037),  -- bloqué en saisie
  ('IV', 'N00038', '2025-03-05', 1015, 200038);  -- bloqué en validation
GO

-- ============================================
-- BULLACTION
-- ============================================
INSERT INTO BullAction (etat, id_etat, num_dossier)
VALUES
  ('TS', 3, 'N00034'), ('EV', 5, 'N00034'), ('TV', 6, 'N00034'),
  ('TS', 3, 'N00035'),
  ('TS', 3, 'N00036'), ('EV', 5, 'N00036'),
  ('TS', 3, 'N00037'),
  ('TS', 3, 'N00038'), ('EV', 5, 'N00038');
GO

-- ============================================
-- BULLACTION REVALIDATION
-- ============================================
INSERT INTO BullActionRevalidation (etat, id_etat, num_dossier)
VALUES
  ('IR', 7, 'N00036'),
  ('IR', 7, 'N00038'), ('ER', 8, 'N00038');
GO

-- ============================================
-- ANOMALIES
-- ============================================
INSERT INTO Anomaly (num_dossier, etat_actuel, cause, correction, date_detection)
VALUES
  ('N00035', 'IS', 'CONTRAT_MAL_SAISI', 'Vérifier le code contrat 1013 dans la table Dossier',         '2025-03-02'),
  ('N00036', 'EV', 'ERREUR_MIGRATION',  'Réimporter le dossier N00036 depuis le système source',       '2025-03-03'),
  ('N00037', 'IS', 'DONNEE_ERRONEE',    'Vérifier la date de naissance et le code adhésion de N00037', '2025-03-04'),
  ('N00038', 'IV', 'CONTRAT_MAL_SAISI', 'Vérifier le code contrat 1015 dans la table Dossier',         '2025-03-05');
GO