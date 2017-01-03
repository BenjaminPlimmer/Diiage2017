#!/bin/bash
#@AIM :Afficher un minishell
#@AUTHORS :THOMAS SERVAGE
#@PARAMS :
#@MODIFS :
read -p "saisir une commande :" Commande

exec $Commande  | echo ${?} &


async1()
{
        sleep 5
        echo " async 1"
        sleep 5
        echo "async 1 finished"
        return 0
}

async2()
{
        sleep 3
        echo "async 2"
        sleep 4
        echo "async 2 finished"
        return 0
}

echo "En cours"
async1 &
async2 &



exit 0






