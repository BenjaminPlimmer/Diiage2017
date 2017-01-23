#!/bin/bash
#@AIM : Mini shell / Execute une commande en asynchrone et retourne le code d'erreur
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

#AIM : Fonction permettant d'exécuter une commande passer en paramètre
#PARAMS : string 
#RETURN : Code d'erreur
function execute () {
	$1
	echo -e "\nRésultat commande '$1' -> $?"
}

while [[ CMD != "q" ]]; do
	read -p "miniShell: " CMD
	if [[ -z "$CMD"  ]]; then
		read -p "miniShell: " CMD
	else
		if [[ $CMD != "q" ]]; then
			execute "$CMD" &
		else
			exit
		fi
	fi
done