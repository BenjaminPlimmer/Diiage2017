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

#pas de temps d'attente quand la commande est longue
#un script pour les cmds courtes et un autre pour les longues