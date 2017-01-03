#!/bin/bash
#@AIM : Liste les processus et les processus enfants
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

currentlevel=0

# Fix le début de l'arborescence à 1
root='1'
echo $root
#AIM : Fonction permettant de faire un arborescence recursive des processus
#      et processus enfant à partir d'un fichier formaté
#      format du fichier : "PID:PPID"
#PARAMS : int[FIRST PID] 
#RETURN : None
function subtree ()
{
    while IFS=":" read enfant parent name
    do
        if [[ "$parent" == "$1" ]]; then
            for (( i = 0; i < $currentlevel; i++ )); do
                echo -e -n "|      "
            done
            echo -e "└------$enfant($name)"
            currentlevel=$((currentlevel+1))
            subtree $enfant
            currentlevel=$((currentlevel-1))
        fi
    done < /tmp/list.csv
}

LIST=$(ls /proc/ | grep "[0-9]")

# Parcours la liste de processus dans /proc et stocke le PID, le nom 
# et le PPID dans des variables.
for i in $LIST; do
    NAME=$(grep "Name" /proc/$i/status 2>/dev/null | awk -F " " {'print $2'}) 
    IDP=$(grep "PPid" /proc/$i/status 2>/dev/null |awk -F " " {'print $2'})
    PID=$(grep -e "^Pid" /proc/$i/status 2>/dev/null |awk -F " " {'print $2'}) 
    echo "$PID:$IDP:$NAME" >> /tmp/list.csv
done

#Affiche tout les processus et non seulement ceux de initd
subtree 0

# Tue le processus voulu (q pour quitter le script)
# Si le n° de processus n'existe pas, message d'erreur
while [[ $REP != "q" ]]; do
    read -p "Quel processus voulez vous tuer ? ("q" pour quitter) : " REP
    if [[ $REP != "q" ]]; then
        RES=$(cat /tmp/list.csv | grep $REP)
        if [[ $? = 0 ]]; then
            kill $REP
        else
            echo -e "ERREUR : $REP ne correspond à aucun processus"
        fi
    else
        rm /tmp/list.csv
        exit
    fi
done