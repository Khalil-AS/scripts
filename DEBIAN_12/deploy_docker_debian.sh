#!/bin/bash

## Auteur : Khalil
## Date : 24/07/24
## Version : rev 2.0

## Objectif :
# Ce script permet un déploiement de Docker sur un système Debian

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Journalisation
exec > >(tee -a deploy_docker.log) 2>&1

# Fonction pour afficher un message de succès
success() {
    echo -e "${GREEN}[SUCCÈS]${NC} $1"
}

# Fonction pour afficher un message d'avertissement
warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

# Fonction pour afficher un message d'erreur et quitter
fail() {
    echo -e "${RED}[ERREUR]${NC} $1" >&2
    exit 1
}

# Début du script
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Déploiement de Docker sur Debian ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""

# Supprimer les paquets Docker existants
echo -e "${YELLOW}Étape 1 : Suppression des paquets Docker existants...${NC}"
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    if ! sudo apt-get remove -y $pkg > /dev/null 2>&1; then
        warning "Le paquet $pkg n'a pas pu être supprimé ou n'existe pas."
    fi
done
success "Paquets Docker existants supprimés avec succès."
echo ""

# Mettre à jour les paquets
echo -e "${YELLOW}Étape 2 : Mise à jour des paquets...${NC}"
if ! sudo apt-get update -y > /dev/null 2>&1; then
    fail "Échec de la mise à jour des paquets."
else
    success "Paquets mis à jour avec succès."
fi
echo ""

# Installer les dépendances nécessaires
echo -e "${YELLOW}Étape 3 : Installation des dépendances...${NC}"
if ! sudo apt-get install -y ca-certificates curl > /dev/null 2>&1; then
    fail "Échec de l'installation des dépendances."
else
    success "Dépendances installées avec succès."
fi
echo ""

# Ajouter la clé GPG officielle de Docker
echo -e "${YELLOW}Étape 4 : Ajout de la clé GPG de Docker...${NC}"
sudo install -m 0755 -d /etc/apt/keyrings > /dev/null 2>&1
if ! sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc > /dev/null 2>&1; then
    fail "Échec de l'ajout de la clé GPG de Docker."
else
    sudo chmod a+r /etc/apt/keyrings/docker.asc > /dev/null 2>&1
    success "Clé GPG de Docker ajoutée avec succès."
fi
echo ""

# Ajouter le repository Docker
echo -e "${YELLOW}Étape 5 : Ajout du repository Docker...${NC}"
if ! echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1; then
    fail "Échec de l'ajout du repository Docker."
else
    success "Repository Docker ajouté avec succès."
fi
echo ""

# Mettre à jour les paquets après l'ajout du repository
echo -e "${YELLOW}Étape 6 : Mise à jour des paquets après ajout du repository...${NC}"
if ! sudo apt-get update -y > /dev/null 2>&1; then
    fail "Échec de la mise à jour des paquets."
else
    success "Paquets mis à jour avec succès."
fi
echo ""

# Installer Docker
echo -e "${YELLOW}Étape 7 : Installation de Docker...${NC}"
if ! sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1; then
    fail "Échec de l'installation de Docker."
else
    success "Docker installé avec succès."
fi
echo ""

# Démarrer et configurer Docker en lancement automatique
echo -e "${YELLOW}Étape 8 : Configuration du service Docker...${NC}"
if ! sudo systemctl start docker.service > /dev/null 2>&1; then
    fail "Échec du démarrage du service Docker."
else
    success "Service Docker démarré avec succès."
fi

if ! sudo systemctl enable docker.service > /dev/null 2>&1; then
    fail "Échec de l'activation du service Docker."
else
    success "Service Docker configuré pour le lancement automatique."
fi
echo ""

# Vérification de l'installation
echo -e "${YELLOW}Étape 9 : Vérification de l'installation...${NC}"
if ! sudo docker run hello-world | grep "Hello from Docker!"; then
    fail "Échec de la vérification de l'installation de Docker."
else
    success "Vérification de l'installation réussie."
fi
echo ""

# Ajout de l'utilisateur courant au groupe Docker
echo -e "${YELLOW}Étape 10 : Ajout de l'utilisateur courant au groupe Docker...${NC}"
if ! sudo usermod -aG docker $USER > /dev/null 2>&1; then
    fail "Échec de l'ajout de l'utilisateur au groupe Docker."
else
    success "Utilisateur ajouté au groupe Docker avec succès."
fi
echo ""

# Fin du script
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Script terminé avec succès ! ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo -e "${YELLOW}Veuillez redémarrer votre session pour que les changements prennent effet.${NC}"