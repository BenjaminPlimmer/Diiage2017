#!/bin/bash
#@AIM : Export base de données mysql en .zip
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None
source import.conf
DATE=$1
BASE=$2
FILE="$BASE-$DATE.sql"

#AIM : Fonction affiche erreur
#PARAMS : None
#RETURN : Affiche l'usage
function error() {
  echo "USAGE : $0 <DATE> <NOM DE LA BASE>";exit
}

if [[ -z $DATE || -z $BASE ]]; then
  error
fi

#YOLO-14-02-2017.sql.tar.gz
REGEX='([0-9][0-9])-([0-9][0-9])-([0-9][0-9][0-9][0-9])'
if [[ $DATE =~ $REGEX ]]; then
  CHECK=$(ls | grep "$DATE")
  if [[ $? != 0 ]]; then
    echo "Aucun fichier d'import ne correspond à cette date. : $DATE";exit
  fi
else
  echo "Format de date incorrect : Jour-Mois-Annee XX-XX-XXXX";exit
fi

if [[ ! -d /var/lib/mysql/$BASE ]]; then
  echo "La base $BASE n'existe pas";exit
fi

if [[ ! -f $FILE.tar.gz ]]; then
  echo "Le fichier $FILE n'existe pas."
  error
fi

tar -xvzf $FILE.tar.gz
mysql -h $REMOTE -u $USER -p$PASSWORD -P $PORT $BASE < $BASE-$DATE.sql
echo -e "Done."
