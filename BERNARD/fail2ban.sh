#!/bin/bash
# AIM: Mise en place d'un système de détection
# AUTHORS: Jérémy BERNARD
#PARAMS: aucun paramètre
#MODIF:
   
   #Boucle des événements tant que le fichier est modifié
   inotifywait -m -e modify /var/log/auth.log | while read event file
do
   # Enregistrement dans un fichier temporaire des dernière adresse IP 
   #contenant une chaine précise de caractère
   if tail /var/log/auth.log | grep "Failed password" | awk {'print $11'} > /tmp/fileIP
   then
       #L'adresse IP est placée dans une variable
       ip = $(cat /tmp/fileIP);
	   #Bannisement de l'adresse IP
	   /sbin/iptables -I INPUT -s $ip -j DROP;
	   echo "Ban IP: "$ip
   fi
done

# Suppression du fichier temporaire utilisé précédemment
rm /tmp/fileIP
