#!/bin/bash
#@AIM : Script d'import de base de données mysql
#@AUTHORS : AULAGNE Jérôme
#@PARAMS : None
#@MODIF : 17/02/2017 - Création du script
#		  21/02/2017 - Ajout des tests et gestion des erreurs.	



#import des credentials
source DB.conf

# Options

 #On stocke le chemin de l'emplacement de sauvegarde
 backup_path="/var/lib/mysql/backup/"
 
 #On stocke la date
 date=$2
 
 #On stocke le nom de la bdd
 db_name=$1
 
 #On stocke le nom du fichier
 FILE=$db_name-$date
 
 
 
 
#AIM : Fonction affichage de l'appel
#PARAMS : None
#RETURN : Affiche l'usage de l'appel des paramètres du script
 function pasDeParam()
 {
	echo "Pas d'argument"
	echo ./export-database.sh "nomBDD" "jour-mois-année"
	exit
 }
 
#Si aucun argument
if [[ -z $db_name ]]
then	
  pasDeParam
fi

# Si la date spécifiée ne correspond à aucun fichier .gz
if [[ ! -z ${FILE}.gz ]]
then
	echo "le fichier :" ${FILE}.gz " n/existe pas"
	echo " Vérifier la date"
	ls -l $backup_path
fi
 
#On décompresse le fichier de sortie .gz en .sql
 unzip $backup_path/${FILE}.gz 
 
#On importe la bdd depuis un fichier .sql
 mysqldump --user=$user --password=$password --host=$host --port=$port $db_name < $backup_path/${FILE}.sql

 
#On affiche le résultat à l'utilisateur
echo "$FILE was imported:"

 
 
 