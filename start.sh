#!/bin/bash

# ============================================
# Anomalix — Script de démarrage
# ============================================

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

BACKEND_DIR="$(pwd)/backend"
FRONTEND_DIR="$(pwd)/frontend"

print_header() {
  echo ""
  echo -e "${BLUE}${BOLD}╔══════════════════════════════════════╗${NC}"
  echo -e "${BLUE}${BOLD}║        Anomalix — Démarrage          ║${NC}"
  echo -e "${BLUE}${BOLD}╚══════════════════════════════════════╝${NC}"
  echo ""
}

print_step() {
  echo ""
  echo -e "${CYAN}${BOLD}▶ $1${NC}"
}

print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
  echo -e "${RED}✗ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${NC}"
}

ask_yes_no() {
  local prompt="$1"
  while true; do
    echo -e "${YELLOW}${prompt} (o/n) : ${NC}\c"
    read -r answer
    case "$answer" in
      [oO]) return 0 ;;
      [nN]) return 1 ;;
      *) echo -e "${RED}Répondre par o ou n${NC}" ;;
    esac
  done
}

# ─── Header ───────────────────────────────────────────────
print_header

# ─── Docker Desktop ───────────────────────────────────────
print_step "Docker Desktop"
if ask_yes_no "Voulez-vous démarrer Docker Desktop ?"; then
  echo -e "${YELLOW}Ouverture de Docker Desktop...${NC}"
  open -a Docker

  echo -e "${YELLOW}Attente du démarrage de Docker...${NC}"
  DOCKER_TIMEOUT=60
  DOCKER_ELAPSED=0
  while ! docker info > /dev/null 2>&1; do
    sleep 2
    DOCKER_ELAPSED=$((DOCKER_ELAPSED + 2))
    echo -ne "${YELLOW}Attente... (${DOCKER_ELAPSED}s)${NC}\r"
    if [ $DOCKER_ELAPSED -ge $DOCKER_TIMEOUT ]; then
      print_error "Docker Desktop n'a pas démarré dans les temps. Vérifiez manuellement."
      exit 1
    fi
  done
  print_success "Docker Desktop est prêt"
else
  print_warning "Docker Desktop ignoré"
fi

# ─── Docker Compose (SQL Server) ──────────────────────────
print_step "Base de données SQL Server"
if ask_yes_no "Voulez-vous démarrer SQL Server via Docker Compose ?"; then
  if ! docker info > /dev/null 2>&1; then
    print_error "Docker n'est pas en cours d'exécution. Démarrez Docker Desktop d'abord."
    exit 1
  fi

  echo -e "${YELLOW}Démarrage de SQL Server...${NC}"
  docker compose up -d

  if [ $? -eq 0 ]; then
    print_success "SQL Server démarré sur le port 1433"
  else
    print_error "Échec du démarrage de SQL Server"
    exit 1
  fi
else
  print_warning "SQL Server ignoré"
fi

# ─── Backend Spring Boot ──────────────────────────────────
print_step "Backend Spring Boot"
if ask_yes_no "Voulez-vous démarrer le backend Spring Boot ?"; then
  if [ ! -d "$BACKEND_DIR" ]; then
    print_error "Dossier backend introuvable : $BACKEND_DIR"
    exit 1
  fi

  echo -e "${YELLOW}Démarrage du backend en arrière-plan...${NC}"
  cd "$BACKEND_DIR"

  # Cherche mvnw ou mvn
  if [ -f "./mvnw" ]; then
    ./mvnw spring-boot:run > /tmp/anomalix-backend.log 2>&1 &
  elif command -v mvn &> /dev/null; then
    mvn spring-boot:run > /tmp/anomalix-backend.log 2>&1 &
  else
    print_error "Maven introuvable. Démarrez le backend manuellement depuis IntelliJ."
    cd - > /dev/null
  fi

  BACKEND_PID=$!
  echo -e "${YELLOW}Attente du démarrage du backend (PID: $BACKEND_PID)...${NC}"

  BACKEND_TIMEOUT=60
  BACKEND_ELAPSED=0
  while ! curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; do
    sleep 2
    BACKEND_ELAPSED=$((BACKEND_ELAPSED + 2))
    echo -ne "${YELLOW}Attente... (${BACKEND_ELAPSED}s)${NC}\r"
    if [ $BACKEND_ELAPSED -ge $BACKEND_TIMEOUT ]; then
      print_warning "Le backend met du temps à démarrer — continuez quand même."
      print_warning "Logs disponibles : tail -f /tmp/anomalix-backend.log"
      break
    fi
  done

  if curl -s http://localhost:8080/actuator/health > /dev/null 2>&1; then
    print_success "Backend disponible sur http://localhost:8080"
  fi

  cd - > /dev/null
else
  print_warning "Backend ignoré — démarrez-le manuellement depuis IntelliJ"
fi

# ─── Frontend Flutter ─────────────────────────────────────
print_step "Frontend Flutter"
if ask_yes_no "Voulez-vous démarrer le frontend Flutter ?"; then
  if [ ! -d "$FRONTEND_DIR" ]; then
    print_error "Dossier frontend introuvable : $FRONTEND_DIR"
    exit 1
  fi

  cd "$FRONTEND_DIR"

  echo ""
  echo -e "${BOLD}Sur quelle plateforme voulez-vous lancer Flutter ?${NC}"
  echo -e "  ${CYAN}1${NC} — macOS (desktop)"
  echo -e "  ${CYAN}2${NC} — Chrome (web)"
  echo -e "  ${CYAN}3${NC} — Simulateur iOS"
  echo -e "  ${CYAN}4${NC} — Émulateur Android"
  echo ""

  while true; do
    echo -e "${YELLOW}Votre choix (1/2/3/4) : ${NC}\c"
    read -r platform_choice
    case "$platform_choice" in
      1)
        FLUTTER_PLATFORM="macos"
        PLATFORM_LABEL="macOS"
        break
        ;;
      2)
        FLUTTER_PLATFORM="chrome"
        PLATFORM_LABEL="Chrome"
        break
        ;;
      3)
        FLUTTER_PLATFORM="ios"
        PLATFORM_LABEL="Simulateur iOS"

        # Vérifie si un simulateur est disponible
        SIMULATOR=$(xcrun simctl list devices available 2>/dev/null | grep "iPhone" | head -1 | awk -F'[()]' '{print $2}')
        if [ -z "$SIMULATOR" ]; then
          print_warning "Aucun simulateur iOS trouvé. Ouvrez Xcode et créez un simulateur."
        else
          echo -e "${YELLOW}Démarrage du simulateur...${NC}"
          xcrun simctl boot "$SIMULATOR" 2>/dev/null
          open -a Simulator 2>/dev/null
          sleep 3
        fi
        break
        ;;
      4)
        FLUTTER_PLATFORM="android"
        PLATFORM_LABEL="Émulateur Android"

        # Vérifie si un émulateur est disponible
        EMULATOR=$(flutter emulators 2>/dev/null | grep "android" | head -1 | awk '{print $1}')
        if [ -n "$EMULATOR" ]; then
          echo -e "${YELLOW}Démarrage de l'émulateur Android...${NC}"
          flutter emulators --launch "$EMULATOR" 2>/dev/null
          sleep 5
        else
          print_warning "Aucun émulateur Android trouvé. Créez-en un depuis Android Studio."
        fi
        break
        ;;
      *)
        echo -e "${RED}Choix invalide. Entrez 1, 2, 3 ou 4.${NC}"
        ;;
    esac
  done

  echo ""
  echo -e "${YELLOW}Lancement de Flutter sur ${PLATFORM_LABEL}...${NC}"
  flutter run -d "$FLUTTER_PLATFORM"

  cd - > /dev/null
else
  print_warning "Frontend ignoré"
fi

# ─── Résumé ───────────────────────────────────────────────
echo ""
echo -e "${BLUE}${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}${BOLD}║            Résumé                    ║${NC}"
echo -e "${BLUE}${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}• Backend  :${NC} http://localhost:8080"
echo -e "${GREEN}• Swagger  :${NC} http://localhost:8080/swagger-ui/index.html"
echo -e "${GREEN}• BDD logs :${NC} docker logs maghrebia-sqlserver"
echo -e "${GREEN}• Backend logs :${NC} tail -f /tmp/anomalix-backend.log"
echo ""