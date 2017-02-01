#!/bin/bash
#@AIM : Script de vérification utilisateur et UID
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None

source=/etc/passwd

user=$(awk  -F: '{print $1}' $source)
uid=$(awk  -F: '{print $3}' $source)


function verifUser
{
	read -p "Quel est l'utilisateur à vérifier ? : " askUser

	userSelect=$(grep "$askUser:" $source | awk -F: '{print $1}')
	uidSelect=$(grep "$askUser:" $source | awk -F: '{print $3}')

	if [[ "$userSelect" = "$askUser" ]]
	then
	        echo "L'utilisateur $askUser existe."
	else
	        echo "L'utilisateur $askUser n'existe pas."
	fi
}

function verifUid
{
	read -p "De quel utilisateur souhaitez-vous avoir l'UID ? : " askUser

	userSelect=$(grep "$askUser:" $source | awk -F: '{print $1}')
	uidSelect=$(grep "$askUser:" $source | awk -F: '{print $3}')

	if [[ "$userSelect" = "$askUser" ]]
	then
	        echo "Voici l'UID de l'utilisateur $askUser : $uidSelect."
	else
	        echo "L'utilisateur $askUser n'existe pas."
	fi
}


function Menu 
{
	read -p "Que faire ? 
	1 - Vérifier l'existence d'un utilisateur 
	2 - Connaître l'UID d'un utilisateur 
	q - Quitter 
	-> " selec

	case "$selec" in
		1)  verifUser
			Menu
		;;

		2)  verifUid
			Menu
		;;
		
		q)  clear
			exit
		;; 

		*)  echo "Commande introuvable"
		    Menu
		;;
	esac
}

Menu