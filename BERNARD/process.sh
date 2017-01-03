#!/bin/bash
# AIM: script listant les processus ainsi que leurs enfants
# AUTHORS: Jérémy BERNARD
#PARAMS: aucun paramètre
#MODIF:

list=$(ls /proc/ | grep"[0-9]")

#Parcours la liste des processus dans /proc
#Stockage dans des variables du nom, du PPID et du PID

for l in $list; do
   name=$(more /proc/$l/status 2>/dev/null | grep "Name" | awk -F " " {'print $2'})
   ppid=$(more /proc/$l/status 2>/dev/null | grep "PPid" | awk -F " " {'print $2'})
   pid=$(more /proc/$l/status 2>/dev/null | grep "Pid" | awk -F " " {'print $2'})
done

#AIM: Fonction ayant pour but la mise en place d'une arborescence
#     des processus et des processus enfants
#     format du fichier : "pid:name:ppid"
#PARAMS: int pid
#RETURN:

currentlevel=0

#Affichage de l'arbre

function Tree()
{
   while IFS=":" read enfant name parent
   do
      if [ "$parent" == "$1" ]; then
         for (( i=0;i<$currentlevel;i++ )); do
            echo -e -n "|     "
         done
         echo -e "L_____$enfant($name)"
         currentlevel=$((currentlevel+1))
         Tree $enfant
         currentlevel=$((currentlevel-1))
      fi
   done < /tmp/process
}

Tree 0

#Suppression du fichier

rem /tmp/process
