#!/bin/bash
#@AIM : check if user exist and get uid
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none

#AIM : check if user exist
#PARAMS : [string] username
function checkUser
{
	if id "$1" >/dev/null 2>&1
	then
			echo "$1 user exists"
			exist=0
	else
			echo "$1 user does not exist"
			exist=1
fi
}

#AIM : get user uid
#PARAMS : [string] username
function getUid {
	id -u $1
	#username=$1
	#awk -F ":" '$1 ~ /$username/ {print $3}' /etc/passwd

}

#AIM : List help with commands to type for menu.sh
#PARAMS : none
function listCommands {
echo -e "1 - Verifier l'existence d'un utilisateur"
echo -e "2 - Connaitre l'UID d'un utilisateur"
echo -e "q - Quitter"
}

Exit=0
while [[ $Exit != 1 ]]
do
	echo "##"
	listCommands
	read -p "enter command : " command
	case "$command" in
		q)
			Exit=1
			;; 
		1)
			clear
			read -p "enter username : " user
			checkUser $user
			
			;;
		2)
			clear
			read -p "enter username : " user
			checkUser $user
			
			if [[ "$exist" = "0" ]]
			then
				getUid $user
			fi
			
			;;
		*)
			clear
			echo "Incorrect command"
			;;
	esac
done

exit 0
