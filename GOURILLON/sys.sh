#!/bin/bash
#@AIM : Afficher des informations sur le systèmes
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#01/02/2017-PARTIEL-Création du script
#
echo "------------------------------------"
echo "Informations système de $HOSTNAME "
echo "------------------------------------"

echo "1 - Liste des disques montés:"
lsblk
echo "-----------------------------"

echo "2 - Espace disque total disponible"
df -k | awk '{ SUM += $3} END { print SUM/1024/1024 "G"}'
echo "-----------------------------"

echo "3 - Nombre de processus en cours:"
ps -ef | wc -l
echo "-----------------------------"


echo "4 - Liste des IPC actuels:"
ipcs
echo "-----------------------------"

echo "5 - Le processus le plus gourmand en CPU"
ps aux | sort -nrk 3,3 | head -n 1
echo "-----------------------------"


echo "6 - L'uptime du système est de:"
uptime -p

echo "-----------------------------"


echo "7 - Taux de remplisage des tables d'inodes"
df -h | awk '{if ($1 != "Filesystem") print $1 " " $5}'
echo "-----------------------------"
