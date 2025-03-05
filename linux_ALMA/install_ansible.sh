#!/bin/bash

## Auteur : Khalil
## Date : 23/02/25
## Version : rev 1

## Objectif :
# Ce script installe pipx et Ansible sur un système AlmaLinux

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Journalisation
exec > >(tee -a install_pipx_ansible.log) 2>&1

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
echo -e "${GREEN} Installation de pipx et Ansible ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""

# Vérifier la version de Python
echo -e "${YELLOW}Étape 1 : Vérification de la version de Python...${NC}"
if ! python3 --version > /dev/null 2>&1; then
    fail "Python 3 n'est pas installé."
else
    success "Python 3 est installé."
fi
echo ""

# Installer pip si nécessaire
echo -e "${YELLOW}Étape 2 : Installation de pip...${NC}"
if ! python3 -m ensurepip --upgrade > /dev/null 2>&1; then
    fail "Échec de l'installation de pip."
else
    success "pip est installé et à jour."
fi
echo ""

# Installer pipx
echo -e "${YELLOW}Étape 3 : Installation de pipx...${NC}"
if ! python3 -m pip install --user pipx > /dev/null 2>&1; then
    fail "Échec de l'installation de pipx."
else
    success "pipx est installé."
fi
echo ""

# Ajouter pipx au PATH
echo -e "${YELLOW}Étape 4 : Ajout de pipx au PATH...${NC}"
if ! grep -q 'export PATH=$PATH:~/.local/bin' ~/.bashrc; then
    echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
    source ~/.bashrc
    success "pipx a été ajouté au PATH."
else
    warning "pipx est déjà dans le PATH."
fi
echo ""

# Vérifier l'installation de pipx
echo -e "${YELLOW}Étape 5 : Vérification de l'installation de pipx...${NC}"
if ! pipx --version > /dev/null 2>&1; then
    fail "Échec de la vérification de pipx."
else
    success "pipx est correctement installé."
fi
echo ""

# Mettre à jour pipx
echo -e "${YELLOW}Étape 6 : Mise à jour de pipx...${NC}"
if ! python3 -m pip install --user --upgrade pipx > /dev/null 2>&1; then
    fail "Échec de la mise à jour de pipx."
else
    success "pipx est à jour."
fi
echo ""

# Installer Ansible avec pipx
echo -e "${YELLOW}Étape 7 : Installation d'Ansible avec pipx...${NC}"
if ! pipx install ansible-core > /dev/null 2>&1; then
    fail "Échec de l'installation d'Ansible."
else
    success "Ansible est installé avec succès."
fi
echo ""

# Installer paramiko
echo -e "${YELLOW}Étape 8 : Installation de paramiko...${NC}"
if ! pip3 install paramiko > /dev/null 2>&1; then
    fail "Échec de l'installation de paramiko."
else
    success "paramiko est installé avec succès."
fi
echo ""

# Injecter paramiko dans l'environnement d'Ansible
echo -e "${YELLOW}Étape 9 : Injection de paramiko dans l'environnement d'Ansible...${NC}"
if ! pipx inject ansible-core paramiko > /dev/null 2>&1; then
    fail "Échec de l'injection de paramiko."
else
    success "paramiko a été injecté dans l'environnement d'Ansible."
fi
echo ""

# Installer passlib
echo -e "${YELLOW}Étape 8 : Installation de passlib...${NC}"
if ! pip3 install passlib > /dev/null 2>&1; then
    fail "Échec de l'installation de passlib."
else
    success "passlib est installé avec succès."
fi
echo ""

# Injecter passlib dans l'environnement d'Ansible
echo -e "${YELLOW}Étape 9 : Injection de paramiko dans l'environnement d'Ansible...${NC}"
if ! pipx inject ansible-core passlib > /dev/null 2>&1; then
    fail "Échec de l'injection de passlib."
else
    success "passlib a été injecté dans l'environnement d'Ansible."
fi
echo ""

# Fin du script
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Installation terminée avec succès ! ${NC}"
echo -e "${GREEN}=============================================${NC}"