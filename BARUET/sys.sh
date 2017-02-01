#!/bin/bash
# AIM     : Creer un script qui donne diverses info sur le système - sujet Partiel
# AUTHORS : Kevin BARUET
# PARAMS  : Pas de parametre.
# MODIFS  :

function Ipcs
{
   echo " "
   echo "IPCs ouverts :"
   echo "------------------------ "
   ipcs -m
   echo "------------------------ "
}

function DiskMount
{
   echo " "
   echo "Disques montes :"
   echo "------------------------ "
   df | awk '{print $1 " monte sur " $6}'
   echo "------------------------ "
}

function FreeSpace
{
   echo " "
   echo "Espace libre :"
   echo "------------------------ "
   free -h | awk 'NR==2 {print $4}'
   echo "------------------------ "
}

function ProcSum
{
   echo " "
   echo "Nombre de processus en cours :"
   echo "------------------------ "
   ps -aux | awk '{procsum+=1} END {print procsum}'
   echo "------------------------ "
}

function ProcCPU
{
   echo " "
   echo "Processus le plus gourmand :"
   echo "------------------------ "
   ps -aux --sort=-pcpu | head -n 2
   echo "------------------------ "
}

function Uptime
{
   echo " "
   echo "Uptime :"
   echo "------------------------ "
   uptime | awk '{print $3}'
   echo "------------------------ "
}

function Inodes
{
   echo " "
   echo "Taux de remplissage des tables d'inodes :"
   echo "------------------------ "
   df -ih | awk '{print $1 " contient " $2 " inodes"}'
   echo "------------------------ "
}

function Menu
{
   echo " "
   echo " ---------------------------------------------- "
   echo "|            Etat global du serveur            |"
   echo " ---------------------------------------------- "
   echo "|  Entrer une valeur :                         |"
   echo "|                                              |"
   echo "| 1 : Disques montes                           |"
   echo "| 2 : Espace total disponible                  |"
   echo "| 3 : Nombre de processus en cours             |"
   echo "| 4 : IPCs ouvert sur la machine               |"
   echo "| 5 : Le processus le plus gourmand en CPU     |"
   echo "| 6 : Uptime                                   |"
   echo "| 7 : Taux de remplissage des tables d'inodes  |"
   echo "|                                              |"
   echo "| M : Affichage du Menu                        |"
   echo "|                                              |"
   echo "| Entrer 'Stop' pour terminer le programme     |"
   echo " ---------------------------------------------- "
   echo " "
}

Menu
val="1"
while [ "$val" != "stop" ]
   do
      echo " "
      echo "Donner une valeur :" 
      read val
      echo " "

      case $val  in
         "1")  DiskMount;;
         "2")  FreeSpace;;
         "3")  ProcSum;;
         "4")  Ipcs  ;;
         "5")  ProcCPU;;
         "6")  Uptime;;
         "7")  Inodes;;
         "M") Menu ;;
         "stop") exit ;;
         *) echo "$val n'est pas une valeur comprise dans le menu"
         echo "Veuillez recommencer.";;
      esac
   done 
