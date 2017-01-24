#!/bin/sh
#AIM : script qui permet de monitorer un poste de part son utilisation mémoire, disque, CPU
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF :
#24/01/2017 - Création et ajout du script.


#AIM: Fonction qui affiche un arbre des processus
#PARAMS:
function proc ()
{
#AIM : Boucle qui recherche les processus présents dans "/proc" , et 
# stocke les PID,PPID & leur noms dans un fichier temporaire "infoProcess" sous "/tmp".
#PARAMS : 

Process=$(find /proc -maxdepth 1 -type d -regex ".*[1-9]"| awk -F "/" '{print $3}')

for i in $Process
   do
	  #stocke dans une variable le nom du processus
      pname=$(grep "Name:" /proc/$i/status 2>/dev/null | awk -F " " '{ print $2 }')
	  #stocke dans une variable le PPID du processus
	  ppid=$(grep "PPid:" /proc/$i/status 2>/dev/null | awk -F " " '{ print $2 }')
	  #stocke dans une variable le PID du processus
	  pid=$(grep "Pid:" /proc/$i/status 2>/dev/null | awk -F " " '{ print $2 }')
	  #stocke dans un fichier temporaire les variables précédentes.
	  echo $i';'$ppid';'$pname >> /tmp/infosprocess
	  
   done

   

#Positionnement au niveau 0 pour l'arbre ( processus père absolu ).
currentlevel=0
root="|"
echo $root

#AIM : Fonction qui crée une arborescence des processus sous forme d'arbre.
#PARAMS : 

function tree 
{
    # Boucle qui va récupérer les infos stockés dans notre fichier temporaire en ommetant les ";"
	while IFS=";" read pid ppid name
	do
	    # Test si l'id de processus parent est égale à l'id du processus en cours.
		if [ "$ppid" == "$1" ]
		then
		    #Boucle qui va parcourir les numéros de processus enfants vis à vis du processus parent précédent.
			for (( i=0; i<$CurrentLevel; i++ ))
			do
			    # affiche le caractère "|      " à chaque niveau actuel en cas de processus enfant lié.
				echo -e -n "|      "
			done
			#affiche le caractère "\-------" ainsi que le pid & nom du processus enfant
			echo -e  "+------$pid($name)"
			#le niveau augmente en cas de processus enfant.
			CurrentLevel=$((CurrentLevel+1))
			tree $pid
			#si le pid du processus est parent ,le niveau diminue.
			CurrentLevel=$((CurrentLevel-1))
		fi
		
	done < /tmp/infosprocess
	
}
#reset de l'arbre.
tree 0

#suppression du fichier tempo.
rm /tmp/infosprocess
}

#AIM: Fonction qui affiche la taille de la mémoire utilisée par les ipc.
#PARAMS:
function ipcSum ()
{
	ipcs|awk '{if ($5 ~ /^[0-9]*/) sum+$5; } END {printf("Taille RAM utilisée: " sum/1048576 "Mo\n")}'
}

#AIM: Fonction qui permet de stopper un processus en cours en supprimant ses processus enfants liés si présent.
#PARAMS:
function stopProc ()
{
  Process=$(find /proc -maxdepth 1 -type d -regex ".*[1-9]"| awk -F "/" '{print $3}')

for i in $Process
   do
	  #stocke dans une variable le nom du processus
      pname=$(grep "Name:" /proc/$i/status 2>/dev/null | awk -F " " '{ print $2 }')
	  #stocke dans une variable le PPID du processus
	  ppid=$(grep "PPid:" /proc/$i/status 2>/dev/null | awk -F " " '{ print $2 }')
	  #stocke dans une variable le PID du processus
	  pid=$(grep "Pid:" /proc/$i/status 2>/dev/null | awk -F " " '{ print $2 }')
	  #stocke dans un fichier temporaire les variables précédentes.
	  echo $i';'$ppid';'$pname >> /tmp/infosprocess
	  
   done
   
   
   
   read -p "Donnez le nom du processus a kill :" name
   
		res=$(grep $name /tmp/infosprocess | awk -F ";" '{print $1}')

		for j in $res
		do
			kill $j
		done	
			echo processus $name kill

	rm /tmp/infosprocess
}

printf "Memory\t\tDisk\t\tCPU\n"

MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
echo "$MEMORY$DISK$CPU"


	
	echo " Press q at any moment to quit"		
	read -p "Que voulez-vous afficher ? ( Processus en cours => process , Mémoire utilisée => mem , Utilisation disque => disque ):" reponse



	if [ $reponse == "process" ]
	then
		read -p "Voulez-vous affichez l'arbre des processus en cours ?" reponse


		if [ $reponse == "oui" ]
		then
			proc | more	
			
			read -p "Voulez-vous arrêtez un processus ?" rep
		
			if [ $reponse == "oui" ]
			then
				stopProc
			fi		
		fi
	fi


	if [ $reponse == "mem" ]
	then
		free -m
	
		read -p "Voulez-vous affichez la mémoire utilisée par les ipc ?" reponse

		if [ $reponse == "oui" ]
		then
			ipcs
			ipcSum
		fi
	fi	

	if [ $reponse == "disque" ]
	then
		df
		read -p "Voulez-vous affichez l'utilisation disque d'une partition choisie ?" reponse


		if [ $reponse == "oui" ]
		then
			read -p "Nom de la partition ? " part
			df -h | grep /^$part/ | awk '{ print $5 " " $1 }'
		fi
	fi



	  




   

