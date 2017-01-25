#!/bin/sh
#AIM : Analyse intrusion SSH 
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF : en cours


#on stocke la date dans une variable.
date="date"

#on stocke le nombre limite de tentatives de mauvais mot de passe.
badCount="2"

#AIM : Boucle sur les event tant que le fichier de log auth est modifié.
#PARAMS :
inotifywait -m -e modify /var/log/auth.log | while read event file
do
	#Si on trouve une ligne avec le mot failed  et ssh on envoi le nombre de tentatives et l'adresse ip dans le fichier temporaire IP-file.
   if (awk '/Failed/ && /ssh/ {x[$(NF-3)]++} END {for (i in x){printf "%1d %s\n", x[i], i}}' /var/log/auth.log| sort -nr ) > /tmp/IP-file;
   then
		#on met le nombre de tentatives dans une variable.
		count=$(cat /tmp/IP-file | cut -d" " -f1)
		
		#on met l'adresse ip dans une variable.
		ip=$(cat /tmp/IP-file | cut -d" " -f2)
		
		#Si le nombre de tentatives dépasse 2 on bannit l'adresse IP ( DROP )
		if  [ $count -ge $badCount ]
		then
				# On indique dans /var/log/messages que l'on drop une IP
				echo $date." Drop de l'IP : "$ip >> /var/log/messages;
				/sbin/iptables -I INPUT -s $ip -j DROP;
		fi	
   fi
done
