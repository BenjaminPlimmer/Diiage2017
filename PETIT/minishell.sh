#!/bin/bash
#@AIM : Execute une commande et retourne son code
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None

#Creation de la fonction cmd qui va recuperer la commande et son code erreur
function cmd
{
        $1
        res=$?

        if [ $res != "0" ]
        then
                echo "Code erreur $res"
        fi
}

#Declaration de la variable shell pour le while
shell="a"

#while
while [ "$shell" != "q" ]
do

		#Lecture de la saisie dans la variable shell et affichage du texte 
        read -p "Taper une commande : " shell

        #test pour verifier ce qui arrive en entree, si different de q on continue
        if [ "$shell" != "q" ]
        then
                cmd "$shell" &

        fi
done