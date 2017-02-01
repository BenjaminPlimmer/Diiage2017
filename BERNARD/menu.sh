#!/bin/bash
#AIM: Créer le menu suivant
#     1 - Vérifier l'existence d'un utilisateur
#     2 - Connaître l'UID d'un utilisateur
#     q - Quitter
#AUTHORS: Jérémy BERNARD
#PARAMS:
#MODIF:
 
#AIM: Vérifier l'existence d'un utilisateur
#PARAMS: 
#RETURN:
function verifUser ()
{
read -p "Votre utilisateur : " user
grep $user /etc/passwd | awk -F ":" {'print $1'}
if [$user = $true]
   then
      echo "L'utilisateur existe"
   else 
      echo "L'utilisateur n'existe pas"
fi
}

#AIM: Afficher l'UID d'un utilisateur
#PARAMS: 
#RETURN:
function affichUID ()
{
read -p "Votre utilisateur : " user
grep $user /etc/passwd | awk -F ":" {'print $3'}
}

# Création du menu
while [ cmd != "q" ]
echo "1 - Vérifier l'existence d'un utilisateur"
echo "2 - Connaître l'UID d'un utilisateur"
echo "q - Quitter"
do
	#Traitement de la variable
    read -p "Votre commande : " cmd
	if [$cmd -eq 1]
	   then
	      verifUser
	   else [$cmd -eq 2]
	      affichUID
	   else
	      echo "Vous n'avez le choix qu'entre 1,2 et q"
	fi
done    
