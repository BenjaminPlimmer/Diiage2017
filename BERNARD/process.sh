#!/bin/bash
# AIM: script listant les processus ainsi que leurs enfants
# AUTHORS: Jérémy BERNARD
#PARAMS: aucun paramètre
#MODIF:

#Parcours la liste des processus dans /proc

list=$(ls /proc/ | grep"[0-9]")

#Stockage dans des variables du nom, du PPID et du PID

for l in $list; do
   name=$(more /proc/$l/status 2>/dev/null | grep "Name" | awk -F " " {'print $2'})
   ppid=$(more /proc/$l/status 2>/dev/null | grep "PPid" | awk -F " " {'print $2'})
   pid=$(more /proc/$l/status 2>/dev/null | grep "Pid" | awk -F " " {'print $2'})
   echo $pid';'$name';'$ppid >>/tmp/process
done

#AIM: Fonction ayant pour but la mise en place d'une arborescence
#     des processus et des processus enfants
#     format du fichier : "pid:name:ppid"
#PARAMS: int pid
#RETURN:

#Initialisation du niveau 0

currentlevel=0

#Affichage de l'arbre

function Tree()
{
   # Récupération des informations contenues dans le fichier
   while IFS=":" read procenfant name procparent
   do
      if [ "$procparent" == "$1" ]; then
         for (( i=0;i<$currentlevel;i++ )); do
            echo -e -n "|     "
         done
         echo -e "L_____$procenfant($name)"
         # Gestion du niveau si il existe un processus enfant (augmentation) ou non (diminution)
         currentlevel=$((currentlevel+1))
         Tree $procenfant
         currentlevel=$((currentlevel-1))
      fi
   done < /tmp/process
}

Tree 0

#Suppression du fichier

rm /tmp/process

#Fichier /tmp/process est bien créé mais aucune arborescence créée en sortie de commande
#lors du lancement du script.
