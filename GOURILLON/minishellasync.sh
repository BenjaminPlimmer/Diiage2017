#!/bin/bash
#@AIM : Afficher le code retour d'une commande en background
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#05/01/2016 - Création du script

#Execute la commande et retourne le code retour
function ex
{
        $1 >/dev/null 2>&1
        echo -e "-- Le code retour de $name est ${?}--"
}

#Saisie utilisateur et appel de la fonction ex
name=""
while [[ $name != "exit" ]]
do

        echo "Saisir la commande :"
        echo "Pour quitter taper 'exit'"
        read name
        ex "$name" &
done
