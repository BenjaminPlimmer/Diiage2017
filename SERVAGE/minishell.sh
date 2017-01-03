#!/bin/bash
#@AIM :Afficher un minishell
#@AUTHORS :THOMAS SERVAGE
#@PARAMS :
#@MODIFS :
read -p "saisir une commande :" Commande

exec $Commande  | echo ${?} &

#AIM : Première fonction asynchrone
#PARAMS :
async1()
{
        sleep 5
        echo " async 1"
        sleep 5
        echo "async 1 finished"
        return 0
}

#AIM : Deuxieme fonction asynchrone
#PARAMS :
async2()
{
        sleep 3
        echo "async 2"
        sleep 4
        echo "async 2 finished"
        return 0
}


echo "En cours"
## appel des fonctions en tache de fond
async1 &
async2 &



exit 0
