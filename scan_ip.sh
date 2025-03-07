#!/bin/bash

# Définir la plage d'adresses IP
startIP="10.13.0.50"
endIP="10.13.0.75"

# Convertir les adresses IP en nombres pour faciliter l'itération
startNum=$(printf "%d\n" 0x$(echo $startIP | awk -F. '{printf "%02x%02x%02x%02x\n" $1 $2 $3 $4}'))
endNum=$(printf "%d\n" 0x$(echo $endIP | awk -F. '{printf "%02x%02x%02x%02x\n" $1 $2 $3 $4}'))

# Parcourir la plage d'adresses IP
for ((i=$startNum; i<=$endNum; i++))
do
    # Convertir le nombre en adresse IP
    ip=$(printf "%d.%d.%d.%d\n" \
        $((0xff & $i>>24)) $((0xff & $i>>16)) $((0xff & $i>>8)) $((0xff & $i)))

    # Tester la connectivité avec ping
    ping -c 1 -W 1 $ip > /dev/null 2>&1

    # Vérifier si l'adresse IP est en ligne
    if [ $? -eq 0 ]; then
        echo "$ip est en ligne"
    else
        echo "$ip n'est pas en ligne"
    fi
done
