#!bin/bash
#@AIM		:Afficher la liste des processus avec leurs enfants/
#@AUTHORS 	:THOMAS SERVAGE
#@PARAMS	:
#	-pid numeric
#@MODIFS	:


function enfant {
$ProcessName=$(grep "Name" $1/status | awk -F ":" '{print $2}')
echo "processus :" $ProcessName "Pid : " $1
#Recherche les dossiers correspondants aux processus
for f in $(find /proc -maxdepth 1 -type d -iregex ".*[1-9]") do
	$NbEnfant=$(grep "PPid" $f/status | awk -F ":" '{print $2}')

## si le PPID contenu dans le fichier correspond au PID passé en paramètre
	if [[ $NbEnfant == $1 ]]
		then
			$NameEnfant=$(grep "Name" $f/status | awk -F ":" '{print $2}')
			echo "processus enfant :" $NameEnfant "Pid : " $1 
			enfant($NbEnfant)
		fi
done
}

enfant($1)

exit
