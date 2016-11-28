#!/bin/bash
# AIM : Afficher les processus et leurs enfants.
# AUTHORS : BARUET KEVIN
# PARAMS : Pas de parametres
# MODIFS :

#On tri les repertoires presents dans /proc qui nous interessent :
dir=/proc/[0-9]*
for f in $dir
   do
      # pour chaque repertoire on extrait les infos qui nous interessent du fichier status
      grep '^Name:\|^Pid:\|^PPid:' $f/status
      echo ""
   done
