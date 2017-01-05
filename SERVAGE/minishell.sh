#!/bin/bash
#@AIM :Afficher un minishell
#@AUTHORS :THOMAS SERVAGE
#@PARAMS :
#@MODIFS :

echo -e "help pour afficher l'aide "
echo -e "quit pour arreter le script "

#AIM : execute et affiche le code retour de la commande
#PARAMS : [string] Commande
function executionAsync {
$1
 echo -e "$1    code retour : ${?}"

}

Quit=0
while [[ $Quit != 1 ]]
do
        echo -e "saisir une commande:"
        read Commande

        if [[ $Commande == "quit" ]]
        then
                Quit=1
        else
        if [[ $Commande == "help" ]]
        then
                echo -e "help pour afficher l'aide"
                echo -e "quit pour arreter le script"
        else
                executionAsync "$Commande" &

        fi
        fi
done

exit 0



