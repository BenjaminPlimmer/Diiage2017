#!/bin/bash
#@AIM : système de détection d'intrusion /
# activité suspecte sur un serveur GNU/Linux via la surveillance
# "temps réel" des logs d'activité
#@AUTHOR : Nicolas Coutinho
#@PARAM : [string] $1 = Action, $2 = Fichier

#AIM : Fonction d'aide
#PARAMS : [string] $1 = Nom du script
#RETURN : Message d'aide
function helpScript ()
{
	echo "USAGE : $1 <notify|ban> <FILE>"
	exit
}

#AIM : Fonction de verification des parametres
#PARAMS : [string] $1 = Action, $2 = Fichier
#RETURN : Message d'erreur et message d'aide
function verify ()
{
	# Si il n'y a pas ou si il manque un parametre
	if [[ $2 == "" ]]
	then
		echo "Parametre manquant"
		helpScript $0
	fi
	# Si l'action ne correspond pas
	if [[ $1 != "ban" && $1 != "notify" ]]
	then
		echo -e "Action $1 incorrecte"
		helpScript $0
	fi
	# Si le fichier en parametre n'existe pas
	if [[ ! -f "$2" ]]
	then
		echo -e "Le fichier $2 n'existe pas"
		helpScript $0
	fi
}

# Si l'utilisateur demande l'aide
if [[ $1 = "--help" ]]
then
	helpScript $0
fi

# Execute le fonction "verify"
verify $1 $2

# Execution de inotify, en attente de modification dans le fichier
while inotifywait -e modify "$2" >/dev/null
do
	#Si l'action est ban, ban l'IP et affiche le message d'information
	if [[ $1 == "ban" ]]
	then
		match=$(tail -1 $2 | grep "Failed password")
		if [[ $match != "" ]]
		then
			ip=$(echo "$match" | cut -f 11 -d " ")
			if [[ $ip != "" ]]
			then
				# Le ban est en commentaire pour eviter les problemes
				#iptables -I INPUT -s $ip -j DROP
				echo -e "BAN:\n\tBanned IP address: $ip"
			fi
		fi
        fi
	# Si l'action est notify, afficher la dernière ligne du fichier de log
	if [[ $1 == "notify" ]]
	then
		echo -e "NOTIFY:\n\tModified File: $2\n\tModified Line: $(tail -1 $2)"
	fi
done
