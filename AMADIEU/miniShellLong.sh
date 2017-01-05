#!/bin/bash
#@AIM : Mini shell / Execute une commande en asynchrone et retourne le code d'erreur
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

#AIM : Fonction permettant d'exécuter une commande passer en paramètre
#PARAMS : string 
#RETURN : Code d'erreur
function execute () {
	$1 >/dev/null
	echo -e $?
}

while [[ CMD != "q" ]]; do
	read -p "miniShell: " CMD
	if [[ $CMD != "q" ]]; then
		execute "$CMD" &
	else
		exit
	fi
done