#!/bin/bash
#@AIM: Script d affichage des processus parents et enfants v2
#@AUTHOR: PETIT Alexandre
#@PARAMS : None
#@MODIF:

#Liste des differents processus
procs=$(ls /proc/ | grep "[0-9]")

for i in $procs; do

        #Posistionnement dans le dossier concerne
        cd /proc/$i

        #Ecriture du processus
        printf "Num Processus : $i"
        #Saut de ligne
        echo " "

        # Affichage du Nom du processus
        awk -F " " 'NR == 1, NR == 1 {print "Nom Processus : " $2}' status

        #Affichage du PPID du processus en fonction du fichier status
        awk -F " " 'NR == 5, NR == 5 {print "Num Processus Parent :  " $2}' status

        #Separation
        echo "____"

done