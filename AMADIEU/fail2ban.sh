#!/bin/bash
#@AIM : implémentant un système de détection d'intrusion /
# activité suspecte sur un serveur GNU/Linux via la surveillance "temps réel"
# des logs d'activité auth.log
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None


#AIM : Fonction permettant d'afficher la dernière ligne du fichier passé en paramètre
#PARAMS : string 
#RETURN : Dernière ligne
function showLine () {
        OUT=$(tail -1 $1)
        echo "$OUT"
}

#AIM : Fonction permettant de banir une IP si la ligne est "Failed password" (1 seul mauvais essaie --> BAN)
#PARAMS : string (Ligne ?|  analyser)
#RETURN : None
function banIP () {
        MATCH=$(echo "$1" | grep "Failed password")
        if [[  $? = 0 ]]; then
                IP=$(echo "$1" | cut -f 11 -d " ")
                IP="$IP"
                iptables -I INPUT -s "$IP" -j DROP
        fi
}

# Si l'utilisateur demande l'aide
# Si l'utilisateur se trompe d'event, renvoie : --help pour event
if [[ $1 = "--help" ]]; then
	echo "USAGE : $0 <FILE> <EVENT>"
	echo "EVENT are : access modify close_write close_nowrite close open moved_to moved_from move move_self create delete delete_self unmount";exit
fi

# TEST si le fichier passé en paramètre existe ou non
# S'il n'existe pas affiche l'usage du script + sortie
if [[ ! -f "$1" ]]; then
        echo -e "Le fichier $1 n'existe pas."
        echo "USAGE : $0 <FILE> <EVENT>"
        exit
fi

# Passe en valeur les paramètres de l'utilisateur
FILE="$1"
while inotifywait -e $2 "$FILE"
do
        showLine $FILE
        banIP "$OUT"
done