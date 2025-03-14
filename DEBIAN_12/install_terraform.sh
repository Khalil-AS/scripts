#!/bin/bash

## Auteur : Khalil
## Date : 14/03/2025
## Version : rev 2.0

## Objectif :
# Ce script permet l'installation de Terraform sur un système Debian/Ubuntu

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Journalisation
LOGFILE="install_terraform.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Fonction pour exécuter une commande et logger le résultat
run_command() {
    local command="$1"
    local description="$2"

    echo -e "${YELLOW}Exécution : $description...${NC}"
    echo -e "Commande : $command" >> "$LOGFILE"
    echo -e "----------------------------------------" >> "$LOGFILE"

    if eval "$command" >> "$LOGFILE" 2>&1; then
        echo -e "${GREEN}[SUCCÈS]${NC} $description"
        echo -e "Résultat : Succès" >> "$LOGFILE"
    else
        echo -e "${RED}[ERREUR]${NC} Échec de : $description"
        echo -e "Résultat : Échec" >> "$LOGFILE"
        fail "Échec de l'étape : $description"
    fi

    echo -e "----------------------------------------" >> "$LOGFILE"
    echo ""
}

# Fonction pour afficher un message d'erreur et quitter
fail() {
    echo -e "${RED}[ERREUR]${NC} $1" >&2
    exit 1
}

# Début du script
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Installation de Terraform sur Debian/Ubuntu ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""

# Mettre à jour les paquets
run_command "sudo apt-get update -y" "Mise à jour des paquets"

# Installer les dépendances nécessaires
run_command "sudo apt-get install -y gnupg software-properties-common" "Installation des dépendances"

# Télécharger et ajouter la clé GPG de HashiCorp
run_command "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null" "Ajout de la clé GPG de HashiCorp"

# Vérifier la clé GPG
run_command "gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint" "Vérification de la clé GPG"

# Ajouter le repository HashiCorp
run_command "echo 'deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main' | sudo tee /etc/apt/sources.list.d/hashicorp.list" "Ajout du repository HashiCorp"

# Mettre à jour les paquets après l'ajout du repository
run_command "sudo apt-get update -y" "Mise à jour des paquets après ajout du repository"

# Installer Terraform
run_command "sudo apt-get install -y terraform" "Installation de Terraform"

# Vérification de l'installation
run_command "terraform --version" "Vérification de l'installation de Terraform"

# Fin du script
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Script terminé avec succès ! ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo -e "${YELLOW}Consultez le fichier de log pour plus de détails : $LOGFILE${NC}"
