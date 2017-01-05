#!/bin/bash
#AIM: création d'un minishell
#AUTHORS: Jérémy BERNARD
#PARAMS:
#MODIF:

while [ cmd != "exit" ]
do
	#Traitement de la variable
    read -p "Votre commande : " cmd
    $cmd

    #Affichage du code erreur
    if [ $? != "0" ]
       then
          echo ${?}
    fi
done
