#!/bin/bash

Fichier="/var/log/auth.log"
Temp=/tmp/auth.txt
while [ true ]
do
        inotifywait -e modify $Fichier

        if tail -n1 /var/log/auth.log  |grep "authentication failure"
        then
                        echo -e "Attention erreur d'authentification magueule"
        fi
done


