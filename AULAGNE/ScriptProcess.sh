#!/bin/sh
#AIM : Récupération de la liste des processus sous forme d'arborescence, en 
# ajoutant le lien de parenté Parent/Enfant et en spécifiant le l'ID de 
# processus et son nom.
#AUTHORS :   
#   -AULAGNE Jérôme
#PARAMS : 
#MODIF :

#AIM : Fonction qui recherche parmis les processus présent dans "/proc" , et 
# affiche les processus Parents ou enfants en fonction du processus père  
# absolu "systemd"
#PARAMS : 
Function EnfantsPèreAbsolu {
   For i in $( find /proc -maxdepth 1 -type d -regex ".*[1-9]" ) 
   Do
	  #stocke dans une variable le nom du processus
      $Pname = grep "Name" /proc/$i/status | awk -F ":" { print $2 } 
	  #stocke dans une variable le PPID du processus
	  $PPID = grep "PPID" /proc/$i/status | awk -F ":" { print $2 }
	  #stocke dans une variable le PID du processus
	  $PID = grep "PID" /proc/$i/status | awk -F ":" { print $2 }   
	  
	  #Test condition , si le processus a un PPID égal à 1 autrement dit égal
	  # au PID du processus Père absolu 
	  If [[$PPID = 1 ]]
	  then
		# alors afficher le nom du processus et son PID en décalé sur l'affichage
		echo "\--- $Pname ( $PID )" 
	  else
	  # sinon afficher le nom du processus et son PID sans le décaler sur 
	  # l'affichage
		echo " $Pname ( $PID ) " 
	  fi
   Done

}

 
