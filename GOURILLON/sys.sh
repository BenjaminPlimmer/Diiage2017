#!/bin/bash
#@AIM : Afficher des informations sur le systèmes
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#01/02/2017-PARTIEL-Création du script
#

echo "Liste des disques montés:"
lsblk
echo "-----------------------------"


echo "Nombre de processus en cours:"
ps -ef | wc -l
echo "-----------------------------"




echo "Liste des IPC actuels:"
ipcs
echo "-----------------------------"



echo "Le processus le plus gourmand en CPU"
ps aux | sort -nrk 3,3 | head -n 1
echo "-----------------------------"



echo "L'uptime du système est de:"
uptime -p

echo "-----------------------------"


echo "Taux de remplisage des tables d'inodes"
df -h | awk '{if ($1 != "Filesystem") print $1 " " $5}'
echo "-----------------------------"
