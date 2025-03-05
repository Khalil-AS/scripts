#!/bin/bash

## Auteur : Khalil
## Date : 25/02/25
## Version : rev 1

## Objectif :
# Ce script installe Git, Make et Neofetch sur un système utilisant DNF (ex: Fedora, AlmaLinux, RHEL)

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Journalisation
exec > >(tee -a install_neofetch.log) 2>&1

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
echo -e "${GREEN} Installation de Git, Make et Neofetch ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""

# Mise à jour des paquets
echo -e "${YELLOW}Étape 1 : Mise à jour des paquets...${NC}"
sudo dnf update -y > /dev/null 2>&1 && success "Mise à jour terminée." || fail "Échec de la mise à jour."
echo ""

# Installation de Git et Make
echo -e "${YELLOW}Étape 2 : Installation de Git et Make...${NC}"
sudo dnf install git make -y > /dev/null 2>&1 && success "Git et Make installés avec succès." || fail "Échec de l'installation de Git et Make."
echo ""

# Clonage du dépôt Neofetch
echo -e "${YELLOW}Étape 3 : Clonage du dépôt Neofetch...${NC}"
git clone https://github.com/dylanaraps/neofetch > /dev/null 2>&1 && success "Dépôt Neofetch cloné avec succès." || fail "Échec du clonage du dépôt Neofetch."
echo ""

# Installation de Neofetch
echo -e "${YELLOW}Étape 4 : Installation de Neofetch...${NC}"
cd neofetch && sudo make install > /dev/null 2>&1 && success "Neofetch installé avec succès." || fail "Échec de l'installation de Neofetch."
cd ..
echo ""

# Nettoyage des fichiers
echo -e "${YELLOW}Étape 5 : Nettoyage des fichiers temporaires...${NC}"
rm -rf neofetch && success "Fichiers temporaires supprimés." || warning "Impossible de supprimer les fichiers temporaires."
echo ""

# Vérification de l'installation de Neofetch
echo -e "${YELLOW}Étape 6 : Vérification de Neofetch...${NC}"
if command -v neofetch > /dev/null 2>&1; then
    success "Neofetch est installé et fonctionnel."
    echo ""
    neofetch
else
    fail "Neofetch n'est pas installé correctement."
fi

echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Installation terminée avec succès ! ${NC}"
echo -e "${GREEN}=============================================${NC}"
