#!/bin/bash
#@AIM : Permet de verifier l'existence d'un utilisateur et connaire l'UID d'un utilisateur
#@AUTHORS : Nicolas Coutinho
#@PARAMS : None
#@MODIF : None

#AIM : Fonction qui affiche le menu
#PARAMS : None
#RETURN : None
function afficheMenu ()
{
        echo -e "1 - Vérifier l'existence d'un utilisateur\n2 - Connaître l'UID d'un utilisateur$
}

#AIM : Fonction qui recherche l'utilisateur et affiche si il existe ou non
#PARAMS : None
#RETURN : None
function userExist()
{
        #tput clear
        read -p "Entrez le nom d'utilisateur à vérifier: " user
        userGrep=$(cat /etc/passwd | grep "^$user:")
        if [[ $userGrep != "" ]]
        then
                echo "$user existe"
        else
                echo "$user n'existe pas"
        fi
}

#AIM : Fonction qui l'UID de l'utilisateur si il existe
#PARAMS : None
#RETURN : None
function userUid()
{
        #tput clear
        read -p "Entrez le nom d'utilisateur pour récupérer son UID: " user
        userGrep=$(cat /etc/passwd | grep "^$user:")
        if [[ $userGrep != "" ]]
        then
                uid=$(echo $userGrep | cut -f 3 -d ":")
                echo "l'UID de $user est : $uid"
        else
                echo "$user n'existe pas"
        fi
}

tput clear
while [[ input != "q" ]]
do
        afficheMenu
        read -p "Entrez le numero d'action: " input
        case $input  in
                "1") userExist ;;
                "2") userUid ;;
                "q") exit ;;
                *) echo -e "\t$input n'est pas une valeur comprise dans le menu" ;;
        esac
done
