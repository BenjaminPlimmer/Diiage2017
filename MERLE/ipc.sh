#!/bin/bash
#@AIM : totalité de la  mémoire des IPC
#@AUTHORS :
#   - MERLE Florian
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#  - essaie de faire le script.  j'etais en arret maladie pendant votre cours.
#
ipcs |awk '{ if ($5 ~ /^[0-9]*$/) SUM += $5} 
END { print "somme des IPC est " SUM/1024/1024 " Mo"}'
