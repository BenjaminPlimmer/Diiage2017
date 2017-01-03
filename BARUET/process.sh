#!/bin/bash
# AIM : Afficher les processus et leurs enfants, en arborescence, et tuer le processus demande.
# AUTHORS : BARUET KEVIN
# PARAMS : Pas de parametres
# MODIFS :

#On trie les repertoires presents dans /proc qui nous interessent :

for f in $(ls /proc | grep '[0-9]$')
   do

      # $f correspond a un processus en cours et possede un repertorie status contenant les infos qui nous interessent :

      pid=$(grep -w "Pid:" /proc/$f/status  2>/dev/null | awk -F " " '{print $2}')
      ppid=$(grep -w "PPid:" /proc/$f/status 2>/dev/null | awk -F " " '{print $2}')
      name=$(grep -w "Name:" /proc/$f/status 2>/dev/null| awk -F " " '{print $2}')
      echo $f';'$ppid';'$name >>/tmp/procTreeTmp
   done
echo " -----------------------------------------------------------  "
echo "| Liste des processus -  PPID :      PID :     NAME :       | "
echo " -----------------------------------------------------------  "

currentlevel=0

function procTree
{
        # la fonction va creer un arbre en fonction des infos extraites precedemment.

        while IFS=";" read pid ppid name # on retrouve les infos separees par des ;
        do
                if [ "$ppid" == "$1" ] # On verifie si le processus etudie possede des enfants en fonction de son PID et de leur PPID
                then
                        for (( i=0; i<$currentlevel; i++ ))
                        do
                                echo -e -n "|      "
                        done
                        echo -e "____ $ppid $pid $name "
                        currentlevel=$((currentlevel+1))
                        procTree $pid
                        currentlevel=$((currentlevel-1))
                fi
        done < /tmp/procTreeTmp
}
procTree 0
rm /tmp/procTreeTmp

echo "Pour tuer un processus rentrer son pid, pour quitter taper: 'stop' "
read kill

if [ "$kill" == "stop" ]
then
        echo "Fin"
        exit
else
kill -15 $kill
fi

#while [ $kill -ne "stop" ]
#   do
#     kill -15 $kill
#     read kill
#   done


