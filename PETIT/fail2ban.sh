#!/bin/bash

#@AIM : Ban d'une ip qui échoue à l'authentification
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None


#Lancement de inotifywait
while inotifywait -e modify /var/log/auth.log
do
	#Récupération des dernières ip du auth.log qui contiennent "Failed password"
	tail /var/log/auth.log | grep "Failed password" |awk {'print $11'} >> /tmp/tmpip
#Parcours du fichier tmpip pour bannir les ip récupérées
	for i in $(cat /tmp/tmpip); 
	do	
		iptables -I INPUT -s $i -j DROP
		echo "L'adresse suivante a été bannie : " $i
		rm /tmp/tmpip
	done
done