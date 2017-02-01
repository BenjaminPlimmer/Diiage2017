#!/bin/bash
#@AIM : création script menu.sh qui propose Vérification existence utilisateur, connaitre uid et quitter
# 
#@AUTHORS :
#   - Florian MERLE
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#	  - 
#   
#Affichage du menu
clear

echo "VOTRE MENU"
echo "1 -- Verification de l'existence de l'utilisateur"
echo "2 -- Connaitre l'UID d'un Utilisateur"
echo "q -- Quitter"

read value


if [ "$value" == "q" ]
then
        exit

fi

read -p "Veuillez entrer votre nom d'utilisateur ici: ? " new_user

#Verification de l'exitence de notre utilisateur choisi
id -u "$new_user"> /dev/null 2>&1
if [ "$?" == "0" ]; then
    echo "utilisateur valide"
else
    echo "votre nom d'utilisateur n'est pas valide."
fi

#Connaitre l'UID d'un utilisateur"
echo `grep $new_user /etc/passwd | cut -d: -f3`

