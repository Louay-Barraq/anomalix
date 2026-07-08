# Anomalix — Système de Détection d'Anomalies de Bulletins de Soins

Anomalix est un système avancé de traitement et de détection d'anomalies de bulletins de soins développé pour **Maghrebia**. Il permet aux adhérents d'assurance de soumettre des bulletins de soins, de suivre les membres de leur famille, et de visualiser l'état de traitement de leurs dossiers. En parallèle, il offre aux administrateurs un tableau de bord puissant pour détecter, analyser et corriger les incohérences de données, les saisies incorrectes et les erreurs de migration.

---

## 🏗️ Architecture Système & Stack Technique

Anomalix est conçu comme une application client-serveur découplée :

*   **Frontend (Flutter)** : Un tableau de bord responsive et multi-plateforme conçu selon les principes modernes de l'UI/UX. Il utilise **Riverpod** pour la gestion d'état, **Dio** pour les requêtes HTTP, **fl_chart** pour la visualisation des KPI, et **Syncfusion DataGrid** pour la gestion des bulletins de soins.
*   **Backend (Spring Boot 3 / Java 25)** : Une API REST qui traite les soumissions de bulletins de soins, gère l'authentification des utilisateurs, et exécute le moteur de détection d'anomalies. Elle s'appuie sur **Spring Data JPA**, **Spring Security**, et **OpenAPI (SpringDoc)**.
*   **Base de Données (MS SQL Server 2022)** : Une base de données relationnelle exécutée dans un conteneur Docker, optimisée avec des index pour détecter rapidement les anomalies de données.

---

## ✨ Fonctionnalités Clés

### 👤 Espace Adhérent
*   **Soumission de Bulletin** : Soumettre des bulletins de soins pour les membres existants.
*   **Gestion des Membres de la Famille** : Ajouter des bénéficiaires (**Conjoint** ou **Enfant**) directement sous le contrat de l'adhérent principal et soumettre leurs bulletins.
*   **Suivi des Bulletins** : Un tableau de bord interactif pour déplier et suivre les étapes de traitement (ex: *Instance de saisie*, *Terminé de validation*, etc.) via des badges d'état.

### 🛡️ Espace Admin
*   **KPI Visuels** : Suivi en temps réel du nombre total d'anomalies détectées, de bulletins bloqués, de contrats mal saisis et d'erreurs de migration.
*   **Surveillance des Bulletins** : Tableau des bulletins bloqués nécessitant une intervention administrative.
*   **Moteur de Détection d'Anomalies** : Lancer des scans automatiques ou manuels sur la base de données pour identifier les anomalies.
*   **Instructions de Résolution** : Vue détaillée de chaque dossier affichant les incohérences de base de données spécifiques et des guides étape par étape pour les corriger.

---

## 🔍 Moteur de Détection d'Anomalies

Les anomalies sont détectées par un moteur basé sur des règles de gestion, s'exécutant quotidiennement à 8h00 du matin via `AnomalyScheduler` (ou déclenché manuellement par les administrateurs). Le moteur évalue actuellement trois règles principales :

| Code de la Règle | Nom de la Règle | Condition de Déclenchement / Cause | Guide de Résolution |
| :--- | :--- | :--- | :--- |
| **`CONTRAT_MAL_SAISI`** | Contrat Mal Saisi | Le bulletin est bloqué et le numéro de contrat dans `BullBord` ne correspond pas au numéro de contrat de l'adhérent dans `Dossier`. | Vérifier le code contrat dans la table `Dossier`. |
| **`DONNEE_ERRONEE`** | Donnée Erronée | Le bulletin est bloqué et contient des champs invalides ou manquants : incohérence de l'identifiant d'adhésion (`adhesion`), valeur de relation `malade` invalide, ou date de naissance manquante. | Corriger l'identifiant d'adhésion, renseigner une relation valide, ou saisir la date de naissance manquante. |
| **`ERREUR_MIGRATION`** | Erreur de Migration | Le bulletin existe dans `BullBord` mais aucun dossier correspondant n'existe dans la table `Dossier`. | Réimporter le dossier depuis le système source. |

---

## 🗄️ Schéma de la Base de Données

La base de données est structurée autour des tables clés suivantes :
*   `Dossier` : Contient les informations des membres (adhérent principal ou bénéficiaires), le numéro de contrat (`contrat`), et le code d'adhésion (`adhesion`).
*   `Utilisateur` : Stocke les identifiants de connexion, les rôles (`admin`, `adherent`), et référence le dossier de l'adhérent principal.
*   `BullBord` : Table de suivi contenant l'état actuel (`etat` comme `IS`, `ES`, `IV`, `EV`, `TV`) des bulletins de soins.
*   `BullAction` & `BullActionRevalidation` : Enregistrent la progression et l'historique des validations des bulletins de soins.
*   `Anomaly` : Stocke les anomalies détectées avec les détails de la cause et les instructions de correction.

---

## 🚀 Mise en Route

### 1. Configuration de la Base de Données (Docker)
Assurez-vous que Docker est installé et démarré, puis lancez le conteneur SQL Server depuis le répertoire racine :
```bash
docker-compose up -d
```
Populez la base de données à l'aide des scripts SQL du répertoire `database/` :
1. Exécutez `database/creation_script.sql` (Crée le schéma, les tables, les index et les données de test initiales).
2. Exécutez `database/auth_and_family.sql` (Crée les utilisateurs, configure les liens de parenté/famille).
3. (Optionnel) Exécutez `database/large_populate_script.sql` ou `database/small_populate_script.sql` pour populer la base de données avec des jeux de données plus réalistes.

### 2. Lancement du Backend (Spring Boot)
Nécessite **Java JDK 25** et **Maven** :
```bash
cd backend
# Compiler et lancer l'application
./mvnw spring-boot:run
```
L'API REST sera accessible sur `http://localhost:8080`. Vous pouvez consulter la documentation Swagger à l'adresse `http://localhost:8080/swagger-ui.html`.

### 3. Lancement du Frontend (Flutter)
Nécessite le **SDK Flutter** :
```bash
cd frontend
# Récupérer les dépendances
flutter pub get
# Lancer l'application
flutter run
```

---

## 🔑 Identifiants de Test

Vous pouvez utiliser les comptes par défaut suivants pour vous connecter et tester le système :

| Nom d'utilisateur | Mot de passe | Rôle | Description |
| :--- | :--- | :--- | :--- |
| `admin` | `admin123` | **Admin** | Accès complet au tableau de bord Admin et à la liste des anomalies |
| `N00006` | `pass0006` | **Adhérent** | Compte de l'adhérent principal Youssef Saidi |
| `N00001` | `pass0001` | **Adhérent** | Compte de l'adhérent principal Mohamed Ben Ali |
