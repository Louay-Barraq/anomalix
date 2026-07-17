USE MaghrebiaAnomalyDB;
GO

-- ============================================
-- 1. Créer la table Role
-- ============================================
CREATE TABLE Role (
    id  INT IDENTITY(1,1) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL UNIQUE
);
GO

-- ============================================
-- 2. Insérer les rôles de base
-- ============================================
INSERT INTO Role (nom) VALUES ('ADMIN');
INSERT INTO Role (nom) VALUES ('ADHERENT');
GO

-- ============================================
-- 3. Créer la table de jointure UtilisateurRole
-- ============================================
CREATE TABLE UtilisateurRole (
    utilisateur_id INT NOT NULL,
    role_id        INT NOT NULL,

    CONSTRAINT PK_UtilisateurRole
        PRIMARY KEY (utilisateur_id, role_id),

    CONSTRAINT FK_UtilisateurRole_Utilisateur
        FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id)
            ON DELETE CASCADE,

    CONSTRAINT FK_UtilisateurRole_Role
        FOREIGN KEY (role_id) REFERENCES Role(id)
);
GO

-- ============================================
-- 4. Migrer les rôles existants vers la nouvelle structure
-- ============================================

-- Admins → rôle ADMIN (role_id = 1)
INSERT INTO UtilisateurRole (utilisateur_id, role_id)
SELECT u.id, 1
FROM Utilisateur u
WHERE u.role = 'admin';

-- Adhérents → rôle ADHERENT (role_id = 2)
INSERT INTO UtilisateurRole (utilisateur_id, role_id)
SELECT u.id, 2
FROM Utilisateur u
WHERE u.role = 'adherent';
GO

-- ============================================
-- 5. Donner le rôle ADMIN à certains adhérents
--    (exemple : N00001 et N00006 ont les deux rôles)
-- ============================================
INSERT INTO UtilisateurRole (utilisateur_id, role_id)
SELECT u.id, 1
FROM Utilisateur u
WHERE u.username IN ('N00001', 'N00006');
GO

-- ============================================
-- 6. Supprimer l'ancienne colonne role de Utilisateur
-- ============================================
ALTER TABLE Utilisateur DROP COLUMN role;
GO

-- ============================================
-- 7. Vérification
-- ============================================
SELECT
    u.username,
    STRING_AGG(r.nom, ', ') AS roles
FROM Utilisateur u
JOIN UtilisateurRole ur ON u.id = ur.utilisateur_id
JOIN Role r ON r.id = ur.role_id
GROUP BY u.username
ORDER BY u.username;
GO