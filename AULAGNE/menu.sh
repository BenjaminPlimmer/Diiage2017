#!/bin/sh
#AIM : 
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF :





#Tant que l'utilisateur ne rentre pas "q" faire ...
echo "######Voici mon menu######" 
select choix in \
"1 - Vérifier l'existance d'un utilisateur " \
"2 - Connaître l'UID d'un utilisateur " \
"q - Quitter " \

do
   case $REPLY in
      1) 
	  #Demande un nom d'utilisateur
		read -p " nom utilisateur ? :" user

	  #Test si l'utilisateur spécifié existe
		grep -i "^${user}" /etc/passwd
			if [ $? -eq 0 ]; then
				echo "L'utilisateur $user existe dans /etc/passwd"
			else
				echo "L'utilisateur $user n/existe pas dans /etc/passwd"
			fi ;;
			
      2) 
	  #Demande un nom d'utilisateur
		read -p " nom utilisateur ? :" user
	  
	  #Affiche l'UID d'un utilisateur spécifié
	  awk -F":" ' /^$user/ {print $3}' /etc/passwd
	  ;;
	  
      3) break 
	  ;;
   esac
done








fi




