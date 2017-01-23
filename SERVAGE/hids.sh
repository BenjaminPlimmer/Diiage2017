#!/bin/bash


# Temp=/tmp/auth.txt

if [[ ! -f "$1" ]]; then
        echo -e "Le fichier $1 n'existe pas."
        exit
fi

Fichier=$1
while [ true ]
do
    inotifywait -e modify $Fichier
	echo " $Fichier a été modifié" 
	exit	
        
done
while [ true ]
do
        inotifywait -e modify /var/log/auth.log

        if tail -n1 /var/log/auth.log  |grep "authentication failure"
        then
                        echo -e "Attention erreur d'authentification magueule"
        fi
done




