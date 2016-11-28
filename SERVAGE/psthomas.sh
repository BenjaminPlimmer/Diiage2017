#!bin/bash
#@AIM		:Afficher la liste des processus avec leurs enfants/
#@AUTHORS 	:THOMAS SERVAGE
#@PARAMS	:
#@MODIFS	:




#Boucle sur les dossiers avec des noms en numérique contenus dans /proc/
for f in $(find $dossier -maxdepth 1 -type d -iregex ".*[1-9]") do
	grep "Name" $f/status | awk -F ":" '{print $2}'
	$nbprocess = $(grep "Pid" $f/status | awk -F ":" '{print $2}')

#Boucle sur les dossiers avec des noms en numérique contenus dans /proc/ et compare le pid et le ppid
#Si égale, c'est un enfant
	for i in $(find $dossier -maxdepth 1 -type d -iregex ".*[1-9]") do
		print "enfants /n"
		$nbenfant = $(grep "PPid" $f/status | awk -F ":" '{print $2}')
		if [[ $nbenfant == $nbprocess ]]
		then
			grep "Name" $f/status | awk -F ":" '{print $2}'
			grep "PPid" $f/status | awk -F ":" '{print $2}'
		fi
	done
done
exit