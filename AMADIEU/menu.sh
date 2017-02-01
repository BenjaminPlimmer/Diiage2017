#!/bin/bash
#@AIM : Script menu pour trouver UID et utilisateur existant
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

#AIM : Fonction permettant de verifier l'existense d'un user
#PARAMS : None 
#RETURN : Affiche l'existense d'un user
function verifUser() {
	read -p "Utilisateur ? : " USER
	CMD=$(getent passwd $USER)
	if [[ $? = "2" ]]; then
		echo "Lutilisateur $USER n'existe pas"
	else echo "L'utilisateur $USER exist."
	fi
}

function verifUID() {
	read -p "Utilisateur ? : " USER
	RES=$(getent passwd $USER | awk -F ":" '{print $3}')
	echo "UID de l'utilisateur $USER : $RES"
}
function printMenu() {
	echo "1 - Vérrifer l'existence d'un utilisateur"
	echo "2 - Connaitre l'UID d'un utilisateur"
	echo "q - Quitter"
	read -p "Choix : " REP
	case $REP in
		1*)
  	verifUser
  	;;
  		2*)
	verifUID
	;;
	esac
}

while [[ $REP != q ]]
do
	printMenu
done