#!/bin/bash
#@AIM : Somme mémoire des IPC
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#23/01/2017 - Création du script
#Envoi de la commande ipcs dans l'entré de awk, puis somme de colone5

ipcs |awk '{ SUM += $5} END { print "La somme mémoire des IPC est de " SUM/1024/1024 " Mo"}' 
