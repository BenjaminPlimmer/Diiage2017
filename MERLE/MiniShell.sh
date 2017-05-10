#!/bin/bash
#@AIM : Création d'un minishell / Execute une commande et retourne
#@AUTHORS :
#   - Florian MERLE
#@PARAMS :
#   - None
#@MODIF :
#   - None

read -p "taper une commande" Commande
exec $Command & echo ${?}
exit 0
