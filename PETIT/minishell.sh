#!/bin/bash
#@AIM : Execute une commande et retourne son code
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None


#Lancement du shell
while [ shell != "exit" ]
do
	#Traitement de la variable $shell
        read -p "Taper une commande : " shell
        $shell

        #Condition sur le code erreur à afficher ou non
        if [ $? != "0" ]
                then
                        echo "Code erreur $?"
        fi
done