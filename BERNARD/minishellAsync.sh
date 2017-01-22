#!/bin/bash
#AIM: création d'un minishell
#AUTHORS: Jérémy BERNARD
#PARAMS:
#MODIF:

function ReturnCode
{
    $cmd
    echo ${?}
}

while [ cmd != "exit" ]
do
   #Traitement de la variable
    read -p "Votre commande : " cmd
	ReturnCode $cmd &
done