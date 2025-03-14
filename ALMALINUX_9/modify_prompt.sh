#!/bin/bash

## Auteur : Khalil
## Date : 25/02/25
## Version : rev 1.0

## Objectif :
# Ce script modifie le prompt pour l'utilisateur courant et root,
# en changeant la couleur de @hostname en bleu et en ajoutant Neofetch au démarrage.

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Fonction pour afficher un message de succès
success() {
    echo -e "${GREEN}[SUCCÈS]${NC} $1"
}

# Fonction pour afficher un message d'erreur et quitter
fail() {
    echo -e "${RED}[ERREUR]${NC} $1" >&2
    exit 1
}

# Début du script
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Modification du prompt et ajout de Neofetch ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""

# Modification du prompt pour l'utilisateur courant
echo -e "${YELLOW}Étape 1 : Modification du prompt pour l'utilisateur '$USER'...${NC}"
echo 'export PS1="\[\033[1;32m\][\u\[\033[1;34m\]@\h\[\033[0m\]:\[\033[1;33m\]\w\[\033[0m\]]\\$ "' >> /home/$USER/.bashrc

# Ajout de Neofetch au démarrage
echo -e "${YELLOW}Ajout de Neofetch au démarrage pour l'utilisateur '$USER'...${NC}"
echo 'neofetch' >> /home/$USER/.bashrc
success "Modification du .bashrc de l'utilisateur '$USER' terminée."
echo ""

# Modification du prompt pour root
echo -e "${YELLOW}Étape 2 : Modification du prompt pour root...${NC}"
sudo cp /home/$USER/.bashrc /root/.bashrc
sudo bash -c 'echo "export PS1=\"\[\033[1;31m\][\u\[\033[1;34m\]@\h\[\033[0m\]:\[\033[1;33m\]\w\[\033[0m\]]\\$ \"" >> /root/.bashrc'

# Ajout de Neofetch au démarrage pour root
echo -e "${YELLOW}Ajout de Neofetch au démarrage pour root...${NC}"
echo 'neofetch' | sudo tee -a /root/.bashrc > /dev/null
success "Modification du .bashrc de root terminée."
echo ""

# Fin du script
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN} Script exécuté avec succès. Réouvrez la session. ${NC}"
echo -e "${GREEN}=============================================${NC}"
