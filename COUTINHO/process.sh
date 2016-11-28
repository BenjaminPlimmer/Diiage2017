#!/bin/bash

# AIM : Affiche la liste des processus et leurs enfants
# Authors : Nicolas Coutinho
# PARAMS :
# MODIF : Creation du script

#Declaration des variables
folders=/proc/[1-9]*
declare -a infos

# Pour chaque dossier dans $folders 
for folder in $folders
do
        # Recupere les valeurs dans un variable
        infos+=$(grep '^Name:\|^Pid:\|^PPid:' $file/status)
done

# Affiche le contenu de la variable
echo $infos

exit
