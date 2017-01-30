#!/bin/bash
# AIM     : Utiliser les differents scripts crees jusqu'ici pour en faire un global qui nous donne une indication
#	          sur l'etat du serveur.
# AUTHORS : Nicolas Coutinho
# PARAMS  : Pas de parametre.
# MODIFS  :

function IpcSum
{
   echo " "
   echo "Memoire utilisee par les IPCs :"
   echo "------------------------ "
   ipcs -m -q >> /tmp/ipcfic.txt
   awk 'BEGIN {FS=" "} ; {} {ipcSum+=$5/1024/1024} END {print ipcSum " Mo"}' /tmp/ipcfic.txt
   rm /tmp/ipcfic.txt
   echo "------------------------ "
}

function GState
{
   cat /etc/*-release
   echo "------------------------ "
}

function CPURAM
{
   echo " "
   echo "Occupation de la RAM : "
   echo "------------------------ "
   RAMTotale=$(printf '%.*f\n' 1 $(free | awk 'NR==2 {print $2/1024/1024}'))
   RAMUsed=$(printf '%.*f\n' 1 $(free | awk 'NR==2 {print $4/1024/1024}'))
   echo " $RAMUsed / $RAMTotale Go"
   echo "------------------------ "
   echo "Occupation du CPU : "
   echo "------------------------ "
   ps -aux | awk 'NR > 1 {cpuSum+=$3} END {print cpuSum "%"}'
}

function Menu
{
   echo " "
   echo " ---------------------------------------------- "
   echo "|            Etat global du serveur            |"
   echo " ---------------------------------------------- "
   echo "|  Entrer une valeur :                         |"
   echo "|                                              |"
   echo "| 1 : Informations generales                   |"
   echo "| 2 : Liste des processus                      |"
   echo "| 3 : Memoire utilise par les IPC              |"
   echo "| 4 : Etat CPU et RAM                          |"
   echo "| 5 : Usage disques                            |"
   echo "|                                              |"
   echo "| M : Affichage du Menu                        |"
   echo "|                                              |"
   echo "| Entrer 'Stop' pour terminer le programme     |"
   echo " ---------------------------------------------- "
   echo " "
}

function Tree
{
   while IFS=":" read Enfant Parent Name
      do
         if [ "$Parent" == "$1" ] 
            then
               for (( i=0; i<$CurrentLevel; i++ ))
                  do
                     echo -e -n "|      "
                  done
               echo -e ".------$Enfant($Name)"
               CurrentLevel=$((CurrentLevel+1))
               Tree $Enfant
               CurrentLevel=$((CurrentLevel-1))
         fi
      done < /tmp/info
}

function procTree
{
   echo " -----------------------------------------------------------  "
   echo "| Liste des processus -  PPID :      PID :     NAME :       | "
   echo " -----------------------------------------------------------  "

   File=$(ls /proc/ | grep "[0-9]")

   #Save pid, ppid and name in file /tmp/info
   #File format pid:ppid:name
   for f in $File
   do
      Name=$(more /proc/$f/status 2>/dev/null | grep "Name" | awk -F " " {'print $2'}) 
      IdParent=$(more /proc/$f/status 2>/dev/null | grep "PPid" |awk -F " " {'print $2'})
      echo "$f:$IdParent:$Name" >> /tmp/info
   done
   CurrentLevel=0
   Tree 0
}

function Disk
{
  df -h
}
rm /tmp/info 2>/dev/null
Menu
val="1"
while [ "$val" != "stop" ]
   do
      echo " "
      echo "Donner une valeur :" 
      read val
      echo " "

      case $val  in
         "1") GState ;;
         "2") procTree ;;
         "3") IpcSum ;;
         "4") CPURAM ;;
         "5") Disk ;;
         "M") Menu ;;
         "stop") exit ;;
         *) echo "$val n'est pas une valeur comprise dans le menu"
         echo "Veuillez recommencer.";;
      esac
done 
