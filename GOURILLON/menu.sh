#!/bin/bash
#@AIM : Verifier l'existance d'un utilisateur et connaitre l'UID d'un utilisateur
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#01/02/2017-PARTIEL-Création du script
#


echo "Saisisez une valeur pour poursuivre:"
echo "1: Vérifier l'existence d'un utilisateur"
echo "2: Connaître l'Uid d'un utilisateur"
echo "q: Quitter"

read value


if [ "$value" == "q" ]
then
        exit
fi


if [ "$value" == "1" ]
then

        echo "Merci de saisir le nom de l'utilisateur à verifier:"
        read user
        grep "^$user:" /etc/passwd > /dev/null && echo "L'utilisateur $user existe" || echo "L'utilisateur $user n'existe pas"
fi


if [ "$value" == "2" ]
then

        echo "Merci de saisir le nom de l'utilisateur pour connaitre son UID:"
        read user
        echo "L'UID de $user est:"
        grep $user /etc/passwd | cut -d: -f3
fi
