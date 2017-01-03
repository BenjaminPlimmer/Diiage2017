#!/bin/bash
#@AIM : Afficher le code retour d'un processus
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#

echo "Saisir le processus :"
read name
$name

echo "Le code retour de $name est ${?}"
