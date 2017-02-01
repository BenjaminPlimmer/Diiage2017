#!/bin/bash
# AIM     : Retrouver un utilisateur, son UID, q pour quitter - sujet Partiel
# AUTHORS : KEVIN BARUET
# PARAMS  : Pas de param
# MODIFS  : 

function menu
{
   echo " "
   echo " ---------------------------------------------- "
   echo "|                    Menu                      |"
   echo " ---------------------------------------------- "
   echo "|  Entrer une valeur :                         |"
   echo "|                                              |"
   echo "| 1 : Verifier l'existence d'un utilisateur    |"
   echo "| 2 : Retrouver l'UID de l'utilisateur         |"
   echo "| q : quitter                                  |"
   echo " ---------------------------------------------- "
   echo " "
}

function exist
{
   echo " "
   echo " ------------------------------------------------------------------------- "
   echo "| Donner un nom d'utilisateur - Entrez 'q' pour revenir au menu precedent |"
   echo " ------------------------------------------------------------------------- "
   echo " "
   user="none"
   while [ "$user" != "q" ]
      do
         echo "Donner un nom d'utilisateur : "
         read user
         if grep -w "$user" /etc/passwd > /bin/nul
            then
               echo " "
               echo "$user existe bien."
               echo " "
            else
               echo " "
               echo "$user introuvable."
               echo " "
         fi
      done
}

function UID
{
   echo " "
   echo " ------------------------------------------------------------------------- "
   echo "| Donner un nom d'utilisateur - Entrez 'q' pour revenir au menu precedent |"
   echo " ------------------------------------------------------------------------- "
   echo " "
   user="none"
   while [ "$user" != "q" ]
      do
         echo "Donner un nom d'utilisateur : "
         read user
         if  grep -w "$user" /etc/passwd > /bin/nul
            then
               echo " "
               echo "l'UID de $user est : "
               grep -w "$user" /etc/passwd > /tmp/menutmp
               awk  -F ":" '{print $3}' /tmp/menutmp
               rm /tmp/menutmp
               echo " "
            else
               echo " "
               echo "$user introuvable."
               echo " "
         fi
      done
}

val="0"
while [ "$val" != "q" ]
   do
      menu
      read val

      case $val  in
         "1") exist ;;
         "2") UID ;;
         "q") exit ;;
         *) echo "$val n'est pas une valeur comprise dans le menu"
            echo "Veuillez recommencer.";;
      esac
   done 

