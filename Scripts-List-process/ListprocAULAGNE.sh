#!/bin/sh
#AIM : Récupération de la liste des processus sous forme d'arborescence, en 
# ajoutant le lien de parenté Parent/Enfant et en spécifiant le l'ID de 
# processus et l'utilisateur qui a lançé le processus
#AUTHORS :   
#   -AULAGNE Jérôme
#PARAMS : 
#MODIF :

# Utilisation de la commande "pstree" qui permet d'afficher sous forme 
# d'arborescence , la liste des processus en respectant le lien de parenté
# , tout en affichant via les options "u" : l'utilisateur ayant lançé le 
# processus , ainsi que l'option "p" : l'id de processus ; l'utilisation de la 
# commande  "less" permet de parcourir l'affichage du contenu ( visualiseur )

pstree -up | less




