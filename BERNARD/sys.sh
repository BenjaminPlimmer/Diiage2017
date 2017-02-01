#!/bin/bash
#AIM: Script affcihant diverses information sur le système
#AUTHORS: Jérémy BERNARD
#PARAMS:
#MODIF:

# Afficher les disques montés sur la machine
echo "Voici les disques montés sur votre machine"
mount -t ext2
mount -t ext3
mount -t ext4
# Afficher l'espace disque disponible
echo "Voici l'espace disque disponible sur votre machine"
df -h | grep "/dev/" | awk -F " " '{print $1": " $4}'
# Afficher le nombre de processus en cours
echo "Voici le nombre de processus en cours sur votre machine"
ps -ef | wc -l
# Afficher les ipc ouverts
echo "Voici la liste des IPC sur votre machine"
ipcs
# Afficher le processus le plus gourmand en cpu
echo "Voici le processus le plus gourmand en cpu sur votre machine"
ps -eo pcpu,args | tail -n +2 | sort -rnk 1 | head -n 1 | awk -F " " '{print $2}'
# Uptime

# taux de remplissage des tables d'inodes
echo "Voici le pourcentage d'inodes sur votre machine"
df -i | awk -F " " '{print $1": " $5}'