#!/bin/bash
#AIM: Compter la somme des IPCs en nb d'octets - et rendre le résultat lisible (en Mo) 
#AUTHORS: Jérémy BERNARD
#PARAMS:
#MODIF:

ipcs |awk -F " " '{SUM += $5} END {print SUM/1024/1024 "Mo"}'

# utilisation de la commande ipcs pour lister les ipc
# somme du 5eme champs de la commande ipc pour récupérer uniquement leurs taille
# écriture du résultat de la somme en Mo