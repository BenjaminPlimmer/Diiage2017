#!/bin/bash
#@AIM : Script de création de base de données mysql auto.
#@AUTHORS : AULAGNE Jérôme
#@PARAMS : None
#@MODIF : 22/02/2017 - Création du script
#		  25/02/2017 - Ajout des tests et gestion des erreurs.	



#import des infos
source auto-db.conf






function nameBDD ()
{

read -p "Quel est le nom de la base de données à créer ?" db_name

#On vérifie que la base existe
#mysql -u$USER -p$PASSWORD -h $REMOTE -e "SHOW DATABASE like 'db_name';"
DBEXISTS=$(mysql -u$USER -p$PASSWORD --batch --skip-column-names -e "SHOW DATABASES LIKE "'$db_name'";"| grep "$db_name" > /dev/null; echo "$?")
if [[ $DBEXISTS -eq 0 ]] 
then
	echo "La base existe déjà"
	read -p "Voulez-vous quand même utiliser cette base y or n ?" rep
	
	if [[ $rep == 'y' ]]
	then
		authHost		
	else
		read -p "Annulée, appuyez une touche pour sortir du script..."
		exit
	fi	
	
else
	#Si la bdd n'existe pas , proposer la création
	read -p "La Database: $db_name n'existe pas, voulez-vous la crée y/n ?" rep
	
	
		if [[ $rep == 'y' ]]
		then
			createBDD
		else
			exit
		fi	
fi
}

function createBDD()
{
	query="create database $db_name;"
	
	#Demande confirmation des infos renseignées
	read -p "Exécution de la commande suivante  : $query , Merci de confirmer (y/n) : " confirmCreateBDD
	
	#Si l'utilisateur confirme
	if [[ $confirmCreateBDD == 'y' ]]
	then
		#mysql -u$USER -p$PASSWORD  -h $REMOTE -e "$query";
		authHost
	else
		read -p "Annulée, appuyez une touche pour sortir du script..."
		exit
	fi	
}

function queryFinale()
{
	db="GRANT ALL PRIVILEGES ON $db_name.* TO $dbuser@'$host' IDENTIFIED BY '$dbpw';FLUSH PRIVILEGES;"
	
	#Demande confirmation des infos renseignées
	read -p "Exécution de la commande suivante  : $db , Merci de confirmer (y/n) : " confirmDB
	
	#Si l'utilisateur confirme
	if [[ $confirmDB == 'y' ]]
	then
		#mysql -u$USER -p$PASSWORD  -e "$db";
		
		
Q1="CREATE DATABASE $db_name;"
#Q2="CREATE USER $dbuser@$host IDENTIFIED BY '$dbpw';"
Q3="GRANT ALL PRIVILEGES ON $db_name.* TO '$dbuser'@'$host' IDENTIFIED BY '$dbpw';"
Q4="flush privileges;"
SQL="${Q1}${Q2}${Q3}${Q4}"
		
		
		mysql -u$USER -p$PASSWORD -h $REMOTE -e "$SQL";
		echo $SQL
		mysql -uroot -proot -e 'show databases';
		confirmDB
		
		#echo "CREATE DATABASE '$db_name';CREATE USER '$dbuser'@'$host' IDENTIFIED BY '$dbpw';GRANT ALL PRIVILEGES ON $db_name.* TO '$dbuser'@'$host' IDENTIFIED BY '$dbpw';;Flush PRIVILEGES;" | mysql -u "$USER" -p"$PASSWORD"
		#mysql -uroot -proot -e 'show databases';		
		
	else
		read -p "Annulée, appuyez une touche pour sortir du script..."
		exit
	fi	
}

function authUser()
{
	#On demande le nom de l'utilisateur qui aura des droits sur la bdd
	read -p "Quel est le nom de l'utilisateur autorisé à utiliser la base de données ?" dbuser
	
	#On vérifie si l'utilisateur existe
	exist="select exists(SELECT User FROM mysql.user WHERE user ='$dbuser');"
	
	query= mysql -u$USER -p$PASSWORD -h $REMOTE -e "$exist";
	
	if [[ ${#query} -eq 1 ]]
	then
		echo "L'utilisateur existe"
	else
		
		echo "L'utilisateur n'existe pas"
		
		
	#Si l'utilisateur n'existe pas , proposer la création
	read -p "Le user: $dbuser n'existe pas, voulez-vous le crée y/n ?" rep
	
	
		if [[ $rep == "y" ]]
		then
			createUser
		else
			exit
		fi
		
	fi
}

function authPass()
{	
val2="0"
	while [[ val2 -eq 0 ]]
	do
		#On demande son mdp
		read -p "Quel est le mot de passe de l'utilisateur minimum '$MINPASSWORD' caractères ? " dbpw
	
		#On vérifie si le mot de passe correspond aux exigences de taille 
		if [[ ${#dbpw} -lt 6 ]]
		then
			echo "Le mot de passe ne respecte pas les critères de sécurité"
		else
			echo "le mot de passe respecte les exigences"
			val2="1"
			authUser
		fi	
	
	done
	
}


function authHost()
{
val1="0"
	while [[ val1 -eq 0 ]]
	do	
		#On demande l'adresse ip 
		read -p "Quel est l'adresse IP d'origine autorisée pour l'utilisateur ?" host
	
		#On vérifie si l'hôte existe
		if [[ "ping -c 1 $host " ]]
		then
			echo " L'hôte répond au ping "
			val1="1"
			authPass
		else
			echo " L'hôte ne répond pas au ping "
		
		fi	
		
	done	
}



function createUser()
{
	req="CREATE USER $dbuser@'$host' IDENTIFIED BY '$dbpw';"
	
	#Demande confirmation des infos renseignées
	read -p "Exécution de la commande suivante  : $req , Merci de confirmer (y/n) : " confirmCreateUser
	
	#Si l'utilisateur confirme
	if [[ $confirmCreateUser -eq 'y' ]]
	then
		#mysql -u$USER -p$PASSWORD -h $REMOTE -e "$req";
		queryFinale
	else
		read -p "Annulée, appuyez une touche pour sortir du script..."
		exit
	fi	
}


function confirmDB()
{
 echo "------------------------------------------"
 echo " Database has been created successfully "
 echo "------------------------------------------"
 echo " DB Info: "
 echo ""
 echo " DB Name: $db_name"
 echo " DB User: $dbuser"
 echo " DB Pass: $dbpw"
 echo ""
 echo "------------------------------------------"
}


nameBDD	



