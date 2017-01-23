#!/bin/bash
# AIM     : Afficher la quantite de memoire occupee par les IPCs.
# AUTHORS : Kevin BARUET
# PARAMS  : Pas de parametre.
# MODIFS  :

echo "Memoire utilisee par les IPCs :"
ipcs -m -q >> /tmp/ipcfic.txt
awk 'BEGIN {FS=" "} ; {ipcSum+=$5/1024/1024} END {print ipcSum " Mo"}' /tmp/ipcfic.txt
rm /tmp/ipcfic.txt
