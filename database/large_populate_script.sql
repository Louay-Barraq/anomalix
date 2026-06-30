-- ============================================
-- Script 2 : Population large de la BD
-- ============================================

USE MaghrebiaAnomalyDB;
GO

-- ============================================
-- DOSSIERS (30 dossiers)
-- ============================================
INSERT INTO Dossier (numero, contrat, adhesion, nom, prenom, adresse, emploi, malade, date_naissance)
VALUES
  ('N00004', 1001, 200004, 'Gharbi',    'Amine',    'Tunis',    'Enseignant',    'adherent', '1978-05-14'),
  ('N00005', 1001, 200005, 'Gharbi',    'Fatma',    'Tunis',    'Enseignant',    'conjoint', '1980-09-22'),
  ('N00006', 1002, 200006, 'Saidi',     'Youssef',  'Bizerte',  'Architecte',    'adherent', '1975-11-03'),
  ('N00007', 1002, 200007, 'Saidi',     'Mariem',   'Bizerte',  'Architecte',    'conjoint', '1977-02-18'),
  ('N00008', 1002, 200008, 'Saidi',     'Adam',     'Bizerte',  NULL,            'enfant',   '2008-06-30'),
  ('N00009', 1003, 200009, 'Jebali',    'Khaled',   'Nabeul',   'Pharmacien',    'adherent', '1982-04-07'),
  ('N00010', 1003, 200010, 'Jebali',    'Olfa',     'Nabeul',   'Pharmacien',    'conjoint', '1984-12-15'),
  ('N00011', 1004, 200011, 'Bouazizi',  'Tarek',    'Monastir', 'Médecin',       'adherent', '1970-08-25'),
  ('N00012', 1004, 200012, 'Bouazizi',  'Rim',      'Monastir', 'Médecin',       'conjoint', '1972-03-11'),
  ('N00013', 1004, 200013, 'Bouazizi',  'Sara',     'Monastir', NULL,            'enfant',   '2005-07-19'),
  ('N00014', 1004, 200014, 'Bouazizi',  'Omar',     'Monastir', NULL,            'enfant',   '2010-01-23'),
  ('N00015', 1005, 200015, 'Hamdi',     'Nizar',    'Sousse',   'Ingénieur',     'adherent', '1988-06-04'),
  ('N00016', 1005, 200016, 'Hamdi',     'Ines',     'Sousse',   'Ingénieur',     'conjoint', '1990-10-17'),
  ('N00017', 1006, 200017, 'Chaabane',  'Rami',     'Sfax',     'Avocat',        'adherent', '1979-02-28'),
  ('N00018', 1006, 200018, 'Chaabane',  'Dorra',    'Sfax',     'Avocat',        'conjoint', '1981-07-09'),
  ('N00019', 1006, 200019, 'Chaabane',  'Lina',     'Sfax',     NULL,            'enfant',   '2012-04-14'),
  ('N00020', 1007, 200020, 'Khelifi',   'Bassem',   'Gafsa',    'Comptable',     'adherent', '1983-09-01'),
  ('N00021', 1007, 200021, 'Khelifi',   'Sana',     'Gafsa',    'Comptable',     'conjoint', '1985-11-27'),
  ('N00022', 1008, 200022, 'Riahi',     'Walid',    'Kairouan', 'Dentiste',      'adherent', '1976-03-16'),
  ('N00023', 1008, 200023, 'Riahi',     'Hajer',    'Kairouan', 'Dentiste',      'conjoint', '1978-08-05'),
  ('N00024', 1008, 200024, 'Riahi',     'Yassin',   'Kairouan', NULL,            'enfant',   '2007-12-20'),
  ('N00025', 1009, 200025, 'Ferchichi', 'Montassar','Tunis',    'Directeur',     'adherent', '1968-01-30'),
  ('N00026', 1009, 200026, 'Ferchichi', 'Lobna',    'Tunis',    'Directeur',     'conjoint', '1970-05-22'),
  ('N00027', 1010, 200027, 'Aloui',     'Mehdi',    'Ariana',   'Développeur',   'adherent', '1992-07-11'),
  ('N00028', 1010, 200028, 'Aloui',     'Ghofrane', 'Ariana',   'Développeur',   'conjoint', '1994-02-03'),
  ('N00029', 1010, 200029, 'Aloui',     'Nour',     'Ariana',   NULL,            'enfant',   '2018-09-08'),
  ('N00030', 1011, 200030, 'Baccouche', 'Slim',     'Manouba',  'Enseignant',    'adherent', '1973-04-19'),
  ('N00031', 1011, 200031, 'Baccouche', 'Wafa',     'Manouba',  'Enseignant',    'conjoint', '1975-06-25'),
  ('N00032', 1012, 200032, 'Triki',     'Anis',     'Ben Arous','Ingénieur',     'adherent', '1986-10-07'),
  ('N00033', 1012, 200033, 'Triki',     'Emna',     'Ben Arous','Ingénieur',     'conjoint', '1988-03-14');
GO

-- ============================================
-- BULLBORD
-- TV = traité, IS/ES = bloqué saisie, IV/EV = bloqué validation
-- ============================================
INSERT INTO BullBord (etat, num_dossier, date, contrat, adhesion)
VALUES
  -- Bulletins traités normalement (TV)
  ('TV', 'N00004', '2025-02-01', 1001, 200004),
  ('TV', 'N00005', '2025-02-03', 1001, 200005),
  ('TV', 'N00006', '2025-02-05', 1002, 200006),
  ('TV', 'N00009', '2025-02-07', 1003, 200009),
  ('TV', 'N00011', '2025-02-08', 1004, 200011),
  ('TV', 'N00015', '2025-02-10', 1005, 200015),
  ('TV', 'N00017', '2025-02-11', 1006, 200017),
  ('TV', 'N00020', '2025-02-12', 1007, 200020),
  ('TV', 'N00022', '2025-02-13', 1008, 200022),
  ('TV', 'N00025', '2025-02-14', 1009, 200025),
  ('TV', 'N00027', '2025-02-15', 1010, 200027),
  ('TV', 'N00030', '2025-02-16', 1011, 200030),
  ('TV', 'N00032', '2025-02-17', 1012, 200032),

  -- Bulletins bloqués en saisie (IS / ES)
  ('IS', 'N00007', '2025-01-10', 1002, 200007),
  ('IS', 'N00008', '2025-01-12', 1002, 200008),
  ('ES', 'N00010', '2025-01-14', 1003, 200010),
  ('IS', 'N00012', '2025-01-15', 1004, 200012),
  ('ES', 'N00013', '2025-01-16', 1004, 200013),
  ('IS', 'N00016', '2025-01-18', 1005, 200016),
  ('ES', 'N00019', '2025-01-20', 1006, 200019),
  ('IS', 'N00021', '2025-01-22', 1007, 200021),
  ('IS', 'N00029', '2025-01-25', 1010, 200029),
  ('ES', 'N00031', '2025-01-27', 1011, 200031),

  -- Bulletins bloqués en validation (IV / EV)
  ('IV', 'N00014', '2025-01-17', 1004, 200014),
  ('EV', 'N00018', '2025-01-19', 1006, 200018),
  ('IV', 'N00023', '2025-01-21', 1008, 200023),
  ('EV', 'N00024', '2025-01-23', 1008, 200024),
  ('IV', 'N00026', '2025-01-24', 1009, 200026),
  ('EV', 'N00028', '2025-01-26', 1010, 200028),
  ('IV', 'N00033', '2025-01-28', 1012, 200033);
GO

-- ============================================
-- BULLACTION
-- ============================================
INSERT INTO BullAction (etat, id_etat, num_dossier)
VALUES
  -- Dossiers traités (TS → EV → TV)
  ('TS', 3, 'N00004'), ('EV', 5, 'N00004'), ('TV', 6, 'N00004'),
  ('TS', 3, 'N00005'), ('EV', 5, 'N00005'), ('TV', 6, 'N00005'),
  ('TS', 3, 'N00006'), ('EV', 5, 'N00006'), ('TV', 6, 'N00006'),
  ('TS', 3, 'N00009'), ('EV', 5, 'N00009'), ('TV', 6, 'N00009'),
  ('TS', 3, 'N00011'), ('EV', 5, 'N00011'), ('TV', 6, 'N00011'),
  ('TS', 3, 'N00015'), ('EV', 5, 'N00015'), ('TV', 6, 'N00015'),
  ('TS', 3, 'N00017'), ('EV', 5, 'N00017'), ('TV', 6, 'N00017'),
  ('TS', 3, 'N00020'), ('EV', 5, 'N00020'), ('TV', 6, 'N00020'),
  ('TS', 3, 'N00022'), ('EV', 5, 'N00022'), ('TV', 6, 'N00022'),
  ('TS', 3, 'N00025'), ('EV', 5, 'N00025'), ('TV', 6, 'N00025'),
  ('TS', 3, 'N00027'), ('EV', 5, 'N00027'), ('TV', 6, 'N00027'),
  ('TS', 3, 'N00030'), ('EV', 5, 'N00030'), ('TV', 6, 'N00030'),
  ('TS', 3, 'N00032'), ('EV', 5, 'N00032'), ('TV', 6, 'N00032'),

  -- Dossiers bloqués en saisie (TS seulement)
  ('TS', 3, 'N00007'),
  ('TS', 3, 'N00008'),
  ('TS', 3, 'N00010'),
  ('TS', 3, 'N00012'),
  ('TS', 3, 'N00013'),
  ('TS', 3, 'N00016'),
  ('TS', 3, 'N00019'),
  ('TS', 3, 'N00021'),
  ('TS', 3, 'N00029'),
  ('TS', 3, 'N00031'),

  -- Dossiers bloqués en validation (TS → EV)
  ('TS', 3, 'N00014'), ('EV', 5, 'N00014'),
  ('TS', 3, 'N00018'), ('EV', 5, 'N00018'),
  ('TS', 3, 'N00023'), ('EV', 5, 'N00023'),
  ('TS', 3, 'N00024'), ('EV', 5, 'N00024'),
  ('TS', 3, 'N00026'), ('EV', 5, 'N00026'),
  ('TS', 3, 'N00028'), ('EV', 5, 'N00028'),
  ('TS', 3, 'N00033'), ('EV', 5, 'N00033');
GO

-- ============================================
-- BULLACTION REVALIDATION
-- Dossiers ayant échoué la validation
-- ============================================
INSERT INTO BullActionRevalidation (etat, id_etat, num_dossier)
VALUES
  ('IR', 7, 'N00014'), ('ER', 8, 'N00014'),
  ('IR', 7, 'N00018'), ('ER', 8, 'N00018'), ('TR', 9, 'N00018'),
  ('IR', 7, 'N00023'),
  ('IR', 7, 'N00026'), ('ER', 8, 'N00026'),
  ('IR', 7, 'N00033');
GO

-- ============================================
-- ANOMALIES
-- ============================================
INSERT INTO Anomaly (num_dossier, etat_actuel, cause, correction, date_detection)
VALUES
  ('N00007', 'IS', 'CONTRAT_MAL_SAISI',   'Vérifier le code contrat 1002 dans la table Dossier',             '2025-01-11'),
  ('N00008', 'IS', 'DONNEE_ERRONEE',      'Vérifier la date de naissance et le code adhésion de N00008',     '2025-01-13'),
  ('N00010', 'ES', 'CONTRAT_MAL_SAISI',   'Vérifier le code contrat 1003 dans la table Dossier',             '2025-01-15'),
  ('N00012', 'IS', 'ERREUR_MIGRATION',    'Réimporter le dossier N00012 depuis le système source',           '2025-01-16'),
  ('N00013', 'ES', 'DONNEE_ERRONEE',      'Vérifier le champ malade — valeur invalide détectée',             '2025-01-17'),
  ('N00014', 'IV', 'CONTRAT_MAL_SAISI',   'Vérifier le code contrat 1004 dans la table Dossier',             '2025-01-18'),
  ('N00016', 'IS', 'ERREUR_MIGRATION',    'Réimporter le dossier N00016 depuis le système source',           '2025-01-19'),
  ('N00018', 'EV', 'DONNEE_ERRONEE',      'Vérifier le champ adhesion — incohérence détectée avec BullBord', '2025-01-20'),
  ('N00019', 'ES', 'CONTRAT_MAL_SAISI',   'Vérifier le code contrat 1006 dans la table Dossier',             '2025-01-21'),
  ('N00021', 'IS', 'ERREUR_MIGRATION',    'Réimporter le dossier N00021 depuis le système source',           '2025-01-23'),
  ('N00023', 'IV', 'DONNEE_ERRONEE',      'Vérifier la date de naissance et le code adhésion de N00023',     '2025-01-22'),
  ('N00024', 'EV', 'CONTRAT_MAL_SAISI',   'Vérifier le code contrat 1008 dans la table Dossier',             '2025-01-24'),
  ('N00026', 'IV', 'ERREUR_MIGRATION',    'Réimporter le dossier N00026 depuis le système source',           '2025-01-25'),
  ('N00028', 'EV', 'DONNEE_ERRONEE',      'Vérifier le champ emploi — valeur manquante dans Dossier',        '2025-01-27'),
  ('N00029', 'IS', 'CONTRAT_MAL_SAISI',   'Vérifier le code contrat 1010 dans la table Dossier',             '2025-01-26'),
  ('N00031', 'ES', 'ERREUR_MIGRATION',    'Réimporter le dossier N00031 depuis le système source',           '2025-01-28'),
  ('N00033', 'IV', 'DONNEE_ERRONEE',      'Vérifier la date de naissance et le code adhésion de N00033',     '2025-01-29');
GO