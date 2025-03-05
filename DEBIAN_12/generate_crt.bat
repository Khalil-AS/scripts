#!/bin/bash
# Script to generate cert with SAN
# Date : 27/02/2024
# Authors : Me and the WEB 
# Source : https://raymii.org/s/tutorials/


# Variables
CERTIFICATE_DIR="/etc/ssl/certs"
PRIVATE_KEY_DIR="/etc/ssl/private"
CERTIFICATE_FILENAME="glpi-selfsigned.crt"
PRIVATE_KEY_FILENAME="glpi-selfsigned.key"
DAYS=356
COUNTRY="FR"
STATE="Haute-Garonne"
LOCATION="Ramonville-Saint-Agne"
ORGANIZATION="ADRAR FORMATION"
ORGANIZATIONAL_UNIT="DSI"
COMMON_NAME="glpi.adrar-formation.com"
SAN="DNS:glpi.adrar-formation.com"
CURVE="secp384r1"
SHA_ALGORITHM="sha384"

# Commande OpenSSL
sudo openssl req -nodes -x509 -sha384 -newkey ec \
-pkeyopt ec_paramgen_curve:$CURVE \
-keyout $PRIVATE_KEY_DIR/$PRIVATE_KEY_FILENAME \
-out $CERTIFICATE_DIR/$CERTIFICATE_FILENAME \
-days $DAYS \
-subj "/C=$COUNTRY/ST=$STATE/L=$LOCATION/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME" \
-addext "subjectAltName = $SAN"
