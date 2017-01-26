#!/bin/bash
#@AIM : Détection d'intrusion avec un script bash
#@AUTHORS : GOURILLON Nicolas
#@PARAMS : None
#@MODIF : 26/01/2017 - Gestion des erreurs
#@MODIF : 26/01/2017 - Gestion du fichier de config

#AIM : Fonction permettant d'afficher la dernière ligne du fichier saisi.
#PARAMS : string 
#RETURN : Dernière ligne
function lastline () {
        line=$(tail -1 $file)
        echo "$line"
}

#AIM : Fonction permettant de banir une IP si "Failed password"
#PARAMS : string
#RETURN : None
function ban () {
        MATCH=$(echo "$line" | grep "Failed password")
        if [[  $? = 0 ]]; then
                IP=$(echo "$1" | cut -f 11 -d " ")
                IP="$IP"
                iptables -I INPUT -s "$IP" -j DROP
				echo "-- BAN: L'adresse ip suivante à été banni --"
				echo $IP
				echo "--------------------------------------------"
		fi
}


#AIM : On test le fichier saisi et affiche un message si il n'existe pas
#AIM : Si --help alors affiche l'aide
#PARAMS : None
#RETURN : None
function testfile () {
	if [[ $file = "--help" ]]; then
		echo "Vous devez saisir un fichier de log à analyser"
		exit
    fi
	
	if [[ ! -f "$file" ]]; then
        echo -e "Le fichier $file n'existe pas."
        saisie
	fi
}


#AIM : Fonction de saisie utilisateur
#PARAMS : None
#RETURN : None
function saisie () {
echo "Merci de saisir le chemin du fichier"
read file
}


#AIM : Fonction de fichier de config "config.txt"
#Désactivé par défaut
#PARAMS : None
#RETURN : None

function fichier_conf () {
 fichier=config.txt
 file=$(head -n 1 $fichier)
}


#Appel des fonctions saisie et testfile
#Pour activer le fichier de configuration il faut décommenter la fonction #fichier_conf et commenter les deux suivantes
#fichier_conf
saisie
testfile


#Surveillance du fichier avec inotifywait
##Appel des fonctions lastline et ban
while inotifywait -e modify "$file"
do
        lastline
		ban "$line"
done
