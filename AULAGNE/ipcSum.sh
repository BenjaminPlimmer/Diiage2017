#!/bin/sh
#AIM : Calcul de la somme de mémoire utilisée par les ipc
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF :

#AIM : Récupération de la mémoire utilisée par les différents ipc sous "mémoire partagée"
#PARAMS :


ipcs -m|awk '{if ($5 ~ /^[0-9]*/) sum+$5; } END {printf("Taille RAM utilisée: " sum/1048576 "Mo\n")}'
