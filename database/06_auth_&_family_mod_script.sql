USE MaghrebiaAnomalyDB;
GO

ALTER TABLE Dossier ADD num_adherent VARCHAR(20) NULL;
GO

ALTER TABLE Dossier
ADD CONSTRAINT FK_Dossier_Adherent
    FOREIGN KEY (num_adherent) REFERENCES Dossier(numero);
GO


CREATE TABLE Utilisateur (
    id            INT IDENTITY(1,1)  PRIMARY KEY,
    username      VARCHAR(50)        NOT NULL UNIQUE,
    password      VARCHAR(255)       NOT NULL,
    role          VARCHAR(10)        NOT NULL CONSTRAINT CHK_Role CHECK (role IN ('admin', 'adherent')),
    num_dossier   VARCHAR(20)        NULL,

    CONSTRAINT FK_Utilisateur_Dossier
        FOREIGN KEY (num_dossier) REFERENCES Dossier(numero)
);
GO


-- Famille Saidi (contrat 1002)
UPDATE Dossier SET num_adherent = 'N00006' WHERE numero IN ('N00007', 'N00008');

-- Famille Jebali (contrat 1003)
UPDATE Dossier SET num_adherent = 'N00009' WHERE numero = 'N00010';

-- Famille Bouazizi (contrat 1004)
UPDATE Dossier SET num_adherent = 'N00011' WHERE numero IN ('N00012', 'N00013', 'N00014');

-- Famille Hamdi (contrat 1005)
UPDATE Dossier SET num_adherent = 'N00015' WHERE numero = 'N00016';

-- Famille Chaabane (contrat 1006)
UPDATE Dossier SET num_adherent = 'N00017' WHERE numero IN ('N00018', 'N00019');

-- Famille Khelifi (contrat 1007)
UPDATE Dossier SET num_adherent = 'N00020' WHERE numero = 'N00021';

-- Famille Riahi (contrat 1008)
UPDATE Dossier SET num_adherent = 'N00022' WHERE numero IN ('N00023', 'N00024');

-- Famille Ferchichi (contrat 1009)
UPDATE Dossier SET num_adherent = 'N00025' WHERE numero = 'N00026';

-- Famille Aloui (contrat 1010)
UPDATE Dossier SET num_adherent = 'N00027' WHERE numero IN ('N00028', 'N00029');

-- Famille Baccouche (contrat 1011)
UPDATE Dossier SET num_adherent = 'N00030' WHERE numero = 'N00031';

-- Famille Triki (contrat 1012)
UPDATE Dossier SET num_adherent = 'N00032' WHERE numero = 'N00033';

-- Famille Gharbi (contrat 1001)
UPDATE Dossier SET num_adherent = 'N00004' WHERE numero = 'N00005';

-- Famille Ayari (contrat 1013)
UPDATE Dossier SET num_adherent = 'N00034' WHERE numero = 'N00035';

-- Famille Derbel (contrat 1014)
UPDATE Dossier SET num_adherent = 'N00036' WHERE numero = 'N00037';
GO


-- Admins
INSERT INTO Utilisateur (username, password, role, num_dossier)
VALUES
  ('admin',  'admin123',  'admin', NULL),
  ('admin2', 'admin456',  'admin', NULL);
GO

-- Adhérents (un compte par adhérent principal)
INSERT INTO Utilisateur (username, password, role, num_dossier)
VALUES
  ('N00001', 'pass0001', 'adherent', 'N00001'),
  ('N00002', 'pass0002', 'adherent', 'N00002'),
  ('N00003', 'pass0003', 'adherent', 'N00003'),
  ('N00004', 'pass0004', 'adherent', 'N00004'),
  ('N00006', 'pass0006', 'adherent', 'N00006'),
  ('N00009', 'pass0009', 'adherent', 'N00009'),
  ('N00011', 'pass0011', 'adherent', 'N00011'),
  ('N00015', 'pass0015', 'adherent', 'N00015'),
  ('N00017', 'pass0017', 'adherent', 'N00017'),
  ('N00020', 'pass0020', 'adherent', 'N00020'),
  ('N00022', 'pass0022', 'adherent', 'N00022'),
  ('N00025', 'pass0025', 'adherent', 'N00025'),
  ('N00027', 'pass0027', 'adherent', 'N00027'),
  ('N00030', 'pass0030', 'adherent', 'N00030'),
  ('N00032', 'pass0032', 'adherent', 'N00032'),
  ('N00034', 'pass0034', 'adherent', 'N00034'),
  ('N00036', 'pass0036', 'adherent', 'N00036'),
  ('N00038', 'pass0038', 'adherent', 'N00038');
GO