#!/bin/bash
#@AIM : Mini shell / Execute une commande et retourne
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

while [[ CMD != "exit" ]]; do
	read -p "miniShell: " CMD
	$CMD
	echo "RESULTAT COMMANDE '$CMD' -> $?"
done