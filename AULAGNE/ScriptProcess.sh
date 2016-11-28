#!/bin/sh
#AIM : Récupération de la liste des processus sous forme d'arborescence, en 
# ajoutant le lien de parenté Parent/Enfant et en spécifiant le l'ID de 
# processus et son nom.
#AUTHORS :   
#   -AULAGNE Jérôme
#PARAMS : 
#MODIF :

#Fonction qui recherche parmis les processus présent dans "/proc" , et affiche
# les processus Parents ou enfants en fonction du processus père absolu 
# "systemd"

Function EnfantsPèreAbsolu {
   For i in $( find /proc -maxdepth 1 -type d -regex ".*[1-9]" ) 
   Do
      $Pname = grep "Name" /proc/$i/status | awk -F ":" { print $2 } #stocke dans une variable le nom du processus
	  $PPID = grep "PPID" /proc/$i/status | awk -F ":" { print $2 }  #stocke dans une variable le PPID du processus
	  $PID = grep "PID" /proc/$i/status | awk -F ":" { print $2 }   #stocke dans une variable le PID du processus
	  
	  #
	  If [[$PID = 1 ]]
	  then
		echo "\--- $Pname ( $PID )"
	  
	  else
		echo " $Pname ( $PID ) "
	  fi
   Done

}
