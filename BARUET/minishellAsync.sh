#!/bin/bash
# AIM     : afficher le code retour d'une commande donnee par un utilisateur, et executer cette commande de maniere asynchrone.
# AUTHORS : Kevin BARUET
# PARAMS  : pas de parametres
# MODIFS  :

function codeRetour
{
   $cmd &
   echo "code retour : " ${?}
}

echo "entrer stop pour terminer le script."
cmd=" "

while [[ $cmd != "stop"  ]]
   do
     echo "Donner nom de processus : "
     read cmd
     codeRetour $cmd &
   done
