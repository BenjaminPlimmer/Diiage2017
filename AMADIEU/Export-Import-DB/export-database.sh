#!/bin/bash
#@AIM : Export base de données mysql en .zip
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

source import.conf

BASE=$1
DATE=$(date +"%d-%m-%Y")
FILE=$BASE-$DATE.sql

#AIM : Fonction affiche les erreurs
#PARAMS : None
#RETURN : Affiche l'usage
function error() {
  echo "USAGE : $0 <NOM BASE DE DONNEE>";exit
}

# Si il n'y a pas d'argument
if [[ -z $BASE ]]; then
  error
fi

# Si la base de données n'existe pas
if [[ ! -d /var/lib/mysql/$BASE ]]; then
  echo "La base $BASE n'existe pas."
  error
fi

mysqldump -h $REMOTE -u $USER -p$PASSWORD -P $PORT $BASE > $FILE
tar -zcvf $FILE.tar.gz $FILE
rm $FILE
