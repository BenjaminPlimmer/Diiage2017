#!/bin/bash

#@AIM : Ban d'une ip qui échoue à l'authentification
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None

#Suppression du fichier avant le lancement
rm /tmp/tmpip
#Récupération des dernières ip du auth.log qui contiennent "Failed password"
tail /var/log/auth.log | grep "Failed password" |awk {'print $11'} >> /tmp/tmpip

#Parcours du fichier tmpip pour bannir les ip récupérées
for i in $(cat /tmp/tmpip); 
do	
	iptables -I INPUT -s $i -j DROP
	echo "L'adresse suivante a été bannie : " $i
done

