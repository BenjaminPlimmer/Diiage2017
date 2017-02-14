#!/bin/bash
#@AIM : Export base de données mysql en .zip
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

# Fichier de configuration autoconfig_mysql.conf
source autoconfig_mysql.conf
CREDENTIALS="mysql -h $REMOTE -u $USER -p$PASSWORD"

#AIM : Fonction affiche la question du choix de l'utilisateur
#PARAMS : None
#RETURN : Retourne une question pour l'utilisateur
EXIST=""
function askUserName() {
  read -p "Nom de l'utilisateur autorisé à utiliser la base : " OKUSER
  EXIST=$(echo "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$OKUSER');" |  $CREDENTIALS | awk 'NR>1')
}

#AIM : Fonction affiche la question du choix du mot de passe
#PARAMS : None
#RETURN : Retourne une question pour l'utilisateur
function askPassword() {
  read -p "Le mot de passe de l'utilisateur ($MINPASSWORD caractère minimum): " OKMDP
  if [[ -z $OKMDP ]]; then
    echo "Erreur : Le mot de passe ne peut pas être nul."; exit
  fi
  COUNT=$(expr length "$OKMDP")
}

# function removeAll() {
#   #DROP DATABASE IF EXISTS $BASE;
    #DROP USER '$OKUSER'@'$REMOTE';
# }

# DEBUT
# Demande le nom de la base à créer
# Si elle existe l'utilisateur et alors invité à continuer ou à quitter.
read -p "Nom de la base à créer : " BASE
if [[ -z $BASE ]]; then
  echo "Erreur la base ne peut être nul"; exit
fi
DBEXIST=$(echo "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$BASE';" | $CREDENTIALS | awk 'NR>1')
if [[ "$DBEXIST" == "$BASE" ]]; then
  echo "La base $BASE existe déjà."
  read -p "Voulez-vous continuer ? : y/n" REP1
  if [[ $REP1 != "y" ]]; then
    exit
  fi
else  BASEEXIST=0
fi

# Demande le nom de l'utilisateur
# Si l'utilisateur n'existe pas il sera créer
# Sinon on continue
askUserName
if [[ $EXIST = 0 ]]; then
  RESUMEUSER="echo L'utilisateur "$OKUSER" à été créer."
  echo "L'utilisateur $OKUSER n'existe pas, il sera créé"
fi

# Demande un mot de passe avec une longueur spécifique,
# Demande en boucle tant que la condition n'est pas respectés
askPassword
while [[ $COUNT -lt $MINPASSWORD ]]; do
  askPassword
done

read -p "L'IP d'origine autorisée pour l'utilisateur : " OKIP
if [[ -z $OKIP ]]; then
  echo "L'adresse IP ne peut pas être nul"; exit
fi

# Création de la base si elle n'existe pas déjà
if [[ $BASEEXIST = 0 ]]; then
  echo "CREATE DATABASE $BASE" | $CREDENTIALS
  RESUMEBASE="echo -e Création de la base  : "$BASE""
fi

# Mot de passe et création de l'utilisateur s'il n'existe pas
echo "GRANT ALL PRIVILEGES ON $BASE.* TO '$OKUSER'@'$OKIP' IDENTIFIED BY '$OKMDP' WITH GRANT OPTION;" | $CREDENTIALS

# Résumé des actions
echo ""
echo "Résumé "
echo "########"
echo -e "Modification effectué sur la base : "$REMOTE""
$RESUMEBASE
$RESUMEUSER
echo -e "Credentials --> $OKUSER:$OKMDP"
echo -e "Full access sur la base "$BASE" à partir de l'ip "$OKIP""
