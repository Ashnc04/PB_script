#!/bin/bash

# Nom du fichier CSV de sortie
OUTPUT_FILE="inventaire.csv"

# En-tête du fichier CSV
echo "Adresse IP,Nom d'hôte,Statut de connexion,Charge du processeur,Utilisation de la RAM,Utilisation du SWAP,Espace disque utilisé,Espace disque disponible,Système d'exploitation,Version du système d'exploitation" > $OUTPUT_FILE

# Collecte des informations
IP_ADDRESS=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
SWAP_USAGE=$(free | grep Swap | awk '{print $3/$2 * 100.0}')
DISK_USED=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
DISK_AVAILABLE=$(df / | grep / | awk '{print $4}')
OS_NAME=$(uname -o)
OS_VERSION=$(uname -r)

# Écriture des informations dans le fichier CSV
echo "$IP_ADDRESS,$HOSTNAME,$UPTIME,$CPU_USAGE,$RAM_USAGE,$SWAP_USAGE,$DISK_USED,$DISK_AVAILABLE,$OS_NAME,$OS_VERSION" >> $OUTPUT_FILE

echo "Inventaire terminé. Les résultats sont enregistrés dans $OUTPUT_FILE."
