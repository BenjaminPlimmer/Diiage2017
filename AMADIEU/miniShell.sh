#!/bin/bash
#@AIM : Mini shell / Execute une commande et retourne code erreur
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

while [[ CMD != "q" ]]; do
	read -p "miniShell: " CMD
	if [[ $CMD != "q" ]]; then
		$CMD
		echo "RESULTAT COMMANDE '$CMD' -> $?"
	else
		exit
	fi
done