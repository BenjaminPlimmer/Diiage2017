#!/bin/bash
#@AIM : Somme mémoire des IPC
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#23/01/2017 - Création du script
#Envoi de la commande ipcs dans l'entrée de awk, verification d'un entier avec une expression reguliére, puis somme de la colone5

ipcs |awk '{ if ($5 ~ /^[0-9]*$/) SUM += $5} END { print "La somme mémoire des IPC est de " SUM/1024/1024 " Mo"}'
