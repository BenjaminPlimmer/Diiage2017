#!bin/bash
#@AIM :Afficher un minishell
#@AUTHORS :THOMAS SERVAGE
#@PARAMS :
#@MODIFS :
read -p "saisir une commande :" Commande
exec $Commande | echo ${?}
exit 0





