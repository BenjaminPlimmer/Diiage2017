#!/bin/bash
# AIM     : afficher le code retour d'une commande donnee par un utilisateur
# AUTHORS : Kevin BARUET
# PARAMS  : pas de parametres
# MODIFS  :

echo "Donner nom de processus : "
read cmd
$cmd
echo "code retour : " ${?}
