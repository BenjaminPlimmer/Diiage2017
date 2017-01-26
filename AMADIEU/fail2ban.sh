#!/bin/bash
#@AIM : implémentant un système de détection d'intrusion /
# activité suspecte sur un serveur GNU/Linux via la surveillance "temps réel"
# des logs d'activité auth.log
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

# Fichier passé en paramètre
FILE="$1"

#AIM : Fonction permettant d'afficher la dernière ligne du fichier passé en paramètre
#PARAMS : string 
#RETURN : Dernière ligne
function showLine () {
        OUT=$(tail -1 $1)
        echo "$OUT"
}

#AIM : Fonction permettant de banir une IP si la ligne est "Failed password" (1 seul mauvais essaie --> BAN)
#PARAMS : string (Ligne à analyser)
#RETURN : None
function banIP () {
        MATCH=$(echo "$1" | grep "Failed password")
        if [[  $? = 0 ]]; then
                IP=$(echo "$1" | cut -f 11 -d " ")
                IP="$IP"
                iptables -I INPUT -s "$IP" -j DROP
        fi
}

#AIM : Fonction affichant un message d'erreur personnalité passé en paramètre
#PARAMS : string (message d'erreur)
#RETURN : Erreur, puis exit
function printError () {
        echo "$1"
        echo "USAGE : $0 <FILE>"
        echo "--help pour avoir l'aide"
        exit
}

# Si l'utilisateur demande l'aide
if [[ $1 = "--help" ]]; then
        echo "Analyse les modifications effectué sur un fichier passé en paramètre"
        echo "Si fichier /var/log/auth.log passé en paramètre, BAN l'IP si connexion SSH invalide"
	echo "USAGE : $0 <FILE>"
	exit
fi

# Test si un fichier à été passé en paramètre
# Sinon quitte
if [[ -z "$1" ]]; then
        printError "Aucun fichier passé en paramètre"
fi

# Test si le fichier passé en paramètre existe. 
# Sinon quitte le script.
if [[ ! -f "$1" ]]; then
        printError "Le fichier $1 n'existe pas."
fi

# Passe en valeur les paramètres de l'utilisateur
while inotifywait -e modify "$FILE"
do
        showLine $FILE
        banIP "$OUT"
done