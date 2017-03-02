#!/bin/bash
#@AIM : Script d'export de base de données mysql en gzip
#@AUTHORS : AULAGNE Jérôme
#@PARAMS : None
#@MODIF : 15/02/2017 - Création du script
#		  19/02/2017 - Ajout des tests et gestion des erreurs.	



#import des credentials
source DB.conf

# Options

 #On stocke le chemin de l'emplacement de sauvegarde
 backup_path="/var/lib/mysql/backup/"
 
 #On stocke la date
 date=$(date +"%d-%b-%Y")
 
 #On stocke le nom de la bdd
 db_name=$1
 
 #On stocke le nom du fichier
 FILE=$db_name-$date.sql 
 
 
 
 
#AIM : Fonction affichage de l'appel
#PARAMS : None
#RETURN : Affiche l'usage de l'appel des paramètres du script
 function pasDeParam()
 {
	echo "Pas d'argument"
	echo ./export-database "nomBDD"
	exit
 }
 
 #AIM : Fonction création du dossier backup
#PARAMS : None
#RETURN : Crée un dossier backup dans /var/lib/mysql
 function createRep()
 {
	cd /var/lib/mysql
	mkdir backup
	echo " Dossier crée "
 
 }
 
#Si aucun argument
if [[ -z $db_name ]]
then	
  pasDeParam
fi
 
#Si le dossier backup n'existe pas
if [[ -d $backup_path ]]
then	
  createRep
fi
 
#On exporte la bdd dans un fichier sql
 mysqldump --user=$user --password=$password --host=$host --port=$port $db_name > $backup_path/$FILE
 #On compresse le fichier de sortie .sql en .gz
 gzip $backup_path/$FILE
 
#On affiche le résultat à l'utilisateur
echo "${FILE}.gz was created:"
cd $backup_path
ls -l ${FILE}.gz
 
# Si le fichier .gz est bien crée , supprimer le .sql
if [[ -z ${FILE}.gz]]
then
  rm $FILE
fi
 
 