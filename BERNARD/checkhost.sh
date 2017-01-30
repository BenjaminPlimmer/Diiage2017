#!/bin/bash
#AIM: Contrôle de la machine hôtes 
#AUTHORS: Jérémy BERNARD
#PARAMS:
#MODIF:

#AIM: Fonction ayant pour but de récupérer
#     les informations relatives au poste
#PARAMS:
#RETURN:
function infoComputer ()
{
   # Nom machine
   name=$(uname -a | awk -F " " '{print $2}')
   # Espace disque
   disk=$(df -h | grep "/dev/" | awk -F " " '{print $1": " $5}')
   #Ram
   totalram=$(free -t | grep "Total:" | awk -F " " '{print $2/1024/1024 " Mo"}')
   usedram=$(free -t | grep "Total:" | awk -F " " '{print $3/1024/1024 " Mo"}')
   freeram=$(free -t | grep "Total:" | awk -F " " '{print $4/1024/1024 " Mo"}')
   # Processeur
   cpu=$(lscpu | grep "Nom de modèle" | awk -F ":" '{print$2}')
   # Swap
   swap=$(swapon -s | grep "partition" | awk -F " " '{print $3/1024/1024 " Mo"}')
   # IPC
   ipc=$(ipcs |awk -F " " '{if ($5 ~ /^[0-9]*$/) SUM += $5} END {print SUM/1024/1024 "Mo"}')
   # Inode
   inode=$(df -i |awk -F " " '{SUM += $3} END {print SUM/1024/1024 "Mo"}')
}

#AIM: Fonction ayant pour but d'afficher les processus 
#PARAMS:
#RETURN:
function proc ()
{
   #Parcours la liste des processus dans /proc
   list=$(ls /proc/ | grep "[0-9]")
   #Stockage dans des variables du nom, du PPID et du PID
   for l in $list; do
      name=$(/proc/$l/status 2>/dev/null | grep "Name" | awk -F " " {'print $2'})
      ppid=$(/proc/$l/status 2>/dev/null | grep "PPid" | awk -F " " {'print $2'})
      pid=$(/proc/$l/status 2>/dev/null | grep "Pid" | awk -F " " {'print $2'})
      echo $pid';'$name';'$ppid
   done
}

#AIM: Fonction ayant pour but d'afficher 
#     les informations relatives au poste
#PARAMS:
#RETURN:
function print ()
{
   echo = " "
   echo = "- - - - - - - - - - - - - - - - - "
   echo = "| Etat de votre machine          |"
   echo = "- - - - - - - - - - - - - - - - - "
   echo = "| Nom de votre machine |" $name "|"
   echo = "| Pourcentage d'espace disque utilisé | " $disk "|"
   echo = "| Ram total |" $totalram "|"
   echo = "| Ram utilisé | "$usedram "|"
   echo = "| Ram disponible |" $freeram "|"
   echo = "| votre cpu |" $cpu "|"
   echo = "| Taille du swap |" $swap "|"
   echo = "| Somme des IPC |" $ipc "|"
   echo = "| Somme des inodes |" $inode "|"
}

# Appel des fonctions
infoComputer
print
proc
