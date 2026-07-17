-- ============================================
-- Base de données : Maghrebia Anomaly Detection
-- ============================================

CREATE DATABASE MaghrebiaAnomalyDB;
GO

USE MaghrebiaAnomalyDB;
GO

-- ============================================
-- TABLE : Dossier
-- ============================================
CREATE TABLE Dossier (
    id          INT IDENTITY(1,1)   PRIMARY KEY,
    numero      VARCHAR(20)         NOT NULL UNIQUE,  -- ex: N00123
    contrat     INTEGER             NOT NULL,
    adhesion    BIGINT              NOT NULL,
    nom         VARCHAR(100)        NOT NULL,
    prenom      VARCHAR(100)        NOT NULL,
    adresse     VARCHAR(255)        NULL,
    emploi      VARCHAR(100)        NULL,
    malade      VARCHAR(20)         NOT NULL,         -- 'adherent', 'conjoint', 'enfant'
    date_naissance DATE             NOT NULL
);
GO

-- ============================================
-- TABLE : BullBord
-- ============================================
CREATE TABLE BullBord (
    id          INT IDENTITY(1,1)   PRIMARY KEY,
    etat        VARCHAR(2)          NOT NULL,         -- IS, ES, TS, IV, EV, TV
    num_dossier VARCHAR(20)         NOT NULL,
    date        DATE                NOT NULL,
    contrat     INT                 NOT NULL,
    adhesion    BIGINT              NOT NULL,

    CONSTRAINT FK_BullBord_Dossier
        FOREIGN KEY (num_dossier) REFERENCES Dossier(numero)
);
GO

-- ============================================
-- TABLE : BullAction
-- ============================================
CREATE TABLE BullAction (
    id          INT IDENTITY(1,1)   PRIMARY KEY,
    etat        VARCHAR(2)          NOT NULL,         -- TS, EV, TV
    id_etat     INTEGER             NOT NULL,         -- 3, 5, 6
    num_dossier VARCHAR(20)         NOT NULL,

    CONSTRAINT FK_BullAction_Dossier
        FOREIGN KEY (num_dossier) REFERENCES Dossier(numero)
);
GO

-- ============================================
-- TABLE : BullActionRevalidation
-- ============================================
CREATE TABLE BullActionRevalidation (
    id          INT IDENTITY(1,1)   PRIMARY KEY,
    etat        VARCHAR(2)          NOT NULL,         -- IR, ER, TR
    id_etat     INTEGER             NOT NULL,         -- 7, 8, 9
    num_dossier VARCHAR(20)         NOT NULL,

    CONSTRAINT FK_BullActionReval_Dossier
        FOREIGN KEY (num_dossier) REFERENCES Dossier(numero)
);
GO

-- ============================================
-- TABLE : Anomaly
-- ============================================
CREATE TABLE Anomaly (
    id              INT IDENTITY(1,1)   PRIMARY KEY,
    num_dossier     VARCHAR(20)         NOT NULL,
    etat_actuel     VARCHAR(2)          NOT NULL,     -- IS, ES, IV, EV
    cause           VARCHAR(100)        NOT NULL,     -- 'CONTRAT_MAL_SAISI', etc.
    correction      VARCHAR(500)        NOT NULL,
    date_detection  DATE                NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Anomaly_Dossier
        FOREIGN KEY (num_dossier) REFERENCES Dossier(numero)
);
GO

-- ============================================
-- INDEX utiles pour les requêtes de détection
-- ============================================
CREATE INDEX IDX_BullBord_etat        ON BullBord(etat);
CREATE INDEX IDX_BullBord_num_dossier ON BullBord(num_dossier);
CREATE INDEX IDX_BullAction_num        ON BullAction(num_dossier);
CREATE INDEX IDX_Anomaly_num           ON Anomaly(num_dossier);
GO

-- ============================================
-- DONNÉES DE TEST
-- ============================================

-- Dossiers
INSERT INTO Dossier (numero, contrat, adhesion, nom, prenom, adresse, emploi, malade, date_naissance)
VALUES
  ('N00001', 1001, 200001, 'Ben Ali',   'Mohamed', 'Tunis',   'Ingénieur', 'adherent', '1985-03-12'),
  ('N00002', 1002, 200002, 'Trabelsi',  'Sonia',   'Sfax',    'Médecin',   'conjoint', '1990-07-25'),
  ('N00003', 1003, 200003, 'Mansouri',  'Karim',   'Sousse',  'Comptable', 'enfant',   '2010-01-08');
GO

-- BullBord (quelques bulletins dont certains bloqués)
INSERT INTO BullBord (etat, num_dossier, date, contrat, adhesion)
VALUES
  ('TV', 'N00001', '2025-01-10', 1001, 200001),  -- traité normalement
  ('IS', 'N00002', '2025-01-05', 1002, 200002),  -- bloqué en saisie
  ('IV', 'N00003', '2025-01-03', 1003, 200003);  -- bloqué en validation
GO

-- BullAction
INSERT INTO BullAction (etat, id_etat, num_dossier)
VALUES
  ('TS', 3, 'N00001'),
  ('EV', 5, 'N00001'),
  ('TV', 6, 'N00001'),
  ('TS', 3, 'N00002'),
  ('TS', 3, 'N00003'),
  ('EV', 5, 'N00003');
GO

-- BullActionRevalidation (N00003 a échoué la validation)
INSERT INTO BullActionRevalidation (etat, id_etat, num_dossier)
VALUES
  ('IR', 7, 'N00003'),
  ('ER', 8, 'N00003');
GO

-- Anomalies détectées
INSERT INTO Anomaly (num_dossier, etat_actuel, cause, correction, date_detection)
VALUES
  ('N00002', 'IS', 'CONTRAT_MAL_SAISI',  'Vérifier le code contrat dans la table Dossier', '2025-01-06'),
  ('N00003', 'IV', 'DONNEE_ERRONEE',     'Vérifier la date de naissance et le code adhésion', '2025-01-04');
GO