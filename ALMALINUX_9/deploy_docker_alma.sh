#!/usr/bin/bash

## Auteur : Khalil
## Date : 24/07/24
## Version : rev 2.0

## Objectif :
# Ce script permet un déploiement de Docker sur un système AlmaLinux

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
echo -e "${GREEN} Déploiement de Docker sur AlmaLinux ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""

# Supprimer les potentiels relicas Docker
echo -e "${YELLOW}Étape 1 : Suppression des paquets relicas...${NC}"
if ! sudo dnf remove docker docker-engine docker.io containerd runc podman buildah -y > /dev/null 2>&1; then
    fail "Échec de la suppression des paquets."
else
    success "Paquets relicas supprimés avec succès."
fi
echo ""

# Mise en place du dépot Docker
echo -e "${YELLOW}Étape 2 : Ajout du repository Docker...${NC}"
if ! sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1; then
    fail "Échec de l'ajout du repository Docker."
else
    success "Repository Docker ajouté avec succès."
fi
echo ""

# Installation de Docker
echo -e "${YELLOW}Étape 3 : Installation de Docker...${NC}"
if ! sudo dnf install docker-ce docker-ce-cli containerd.io -y > /dev/null 2>&1; then
    fail "Échec de l'installation de Docker."
else
    success "Docker installé avec succès."
fi
echo ""

# Démarrer et configurer Docker en lancement automatique
echo -e "${YELLOW}Étape 4 : Configuration du service Docker...${NC}"
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

# Afficher la version de Docker
echo -e "${YELLOW}Étape 5 : Affichage de la version de Docker...${NC}"
if ! sudo docker -v; then
    fail "Échec de l'affichage de la version de Docker."
else
    success "Version de Docker affichée avec succès."
fi
echo ""

# Test de vérification
echo -e "${YELLOW}Étape 6 : Vérification de l'installation...${NC}"
if ! sudo docker run hello-world | grep "Hello."; then
    fail "Échec de la vérification de l'installation de Docker."
else
    success "Vérification de l'installation réussie."
fi
echo ""

# Ajout user au groupe Docker
echo -e "${YELLOW}Étape 7 : Ajout de l'utilisateur courant au groupe Docker...${NC}"
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
