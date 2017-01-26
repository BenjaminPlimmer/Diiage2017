#!/bin/sh
#AIM : Analyse intrusion SSH 
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF : 
#25-01-17 - ajout du script fail2ban.
#26-01-17 - Optimisation ( test tous les modifs sur les fichiers de log.

#on stocke le chemin du fichier de log.
#Log='/var/log/auth.log'

#on stocke la date dans une variable.
date="date"

#on stocke le nombre limite de tentatives de mauvais mot de passe.
badCount="3"


#AIM : Fonction ban ip si mot de passe érroné .
#PARAMS :
function banSshFailed
{
	#Si on trouve une ligne avec le mot failed  et ssh on envoi le nombre de tentatives et l'adresse ip dans le fichier temporaire IP-file.
   if (awk '/Failed/ && /ssh/ {x[$(NF-3)]++} END {for (i in x){printf "%1d %s\n", x[i], i}}' $Log| sort -nr ) > /tmp/IP-file;
   then
		#on met le nombre de tentatives dans une variable.
		count=$(cat /tmp/IP-file | cut -d" " -f1)
		
		#on met l'adresse ip dans une variable.
		ip=$(cat /tmp/IP-file | cut -d" " -f2)
		
		#Si le nombre de tentatives dépasse 2 on bannit l'adresse IP ( DROP )
		if  [ $count -ge $badCount ]
		then
				# On indique dans /var/log/messages que l'on drop une IP
				echo $($date)." Ban IP : "$ip
				echo $($date)." Drop de l'IP : "$ip >> /var/log/messages;
				/sbin/iptables -I INPUT -s $ip -j DROP;
		fi	
		
		#on supprime le fichier temporaire.
		rm /tmp/IP-file
   fi
}

#AIM : Boucle qui demande le fichier de log tant que le fichier existe.
#PARAMS :
while [ -f $Log ]
read -p "Entrez un fichier de log (si contrôle accès ssh => /var/log/auth.log) :" Log
do
	#test si le fichier de log existe
	if [ -f $Log ]
	then
	
	#AIM : Boucle sur les event tant que le fichier de log est modifié et existe.
	#PARAMS :
		inotifywait -m -e modify $Log | while read event file
		do
			#on affiche que le fichier a été modifié.
			echo "Fichier modifié : " $Log
	
			#Si le fichier de log est auth.log , on appelle la fonction banSshFailed pour ban l'ip sinon on affiche la dernière ligne du fichier
			if [[ $Log = '/var/log/auth.log' ]]
			then
				echo "Tentative d'attaque par ssh"
				banSshFailed
			else
				#affiche la dernière ligne du fichier de log.
				awk '{ ligne=$0 } END { print ligne }' $Log
			fi
	
	
		done
	else
		echo 'Ce fichier de log n/existe pas'
	
	fi
done
