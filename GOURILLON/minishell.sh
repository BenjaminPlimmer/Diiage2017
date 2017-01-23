#!/bin/bash
#@AIM : Afficher le code retour d'un processus
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#23/01/2017 - Ajout de la boucle while

name=""
while [[ $name != "exit" ]]
do
        echo "Saisir le processus :"
        read name
        #Affichage du resultat de la commande
        $name
        #Affichage du code retour
        echo "Le code retour de $name est ${?}"
done
