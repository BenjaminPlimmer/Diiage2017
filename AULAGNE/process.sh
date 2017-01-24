#!/bin/sh
#AIM : Récupération de la liste des processus sous forme d'arborescence, en 
# ajoutant le lien de parenté Parent/Enfant et en spécifiant le l'ID de 
# processus et son nom.
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF :
#27/12/2016 - Modification de la boucle for initiale - récupération des variables dans une tempo.
#29/12/2016 - Ajout de la fonction d'affichage du résultat de la boucle sous forme d'arbre.

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
			echo -e "+-------$pid($name)"
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
