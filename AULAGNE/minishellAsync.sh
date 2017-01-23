#!/bin/sh
#AIM : Execution d'une commande en arrière plan.
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF :
#03/01/2017 - Ajout du script de demande à l'utilisateur d'une commande et son éxécution en affichant son code erreur ( retour)'
#05/01/2017 - Modification qui lance la commande de manière asynchrone et affiche son code erreur ( retour ).

#AIM : Boucle qui va demander à l'utilisateur de taper une commande tant que "q" équivalent à quit n'est pas renseigné.
#PARAMS : 


while [[ $reponse != "q" ]] #tant que l'utilisateur ne tape pas "q" , on demande une commande a executer.
  do
    read -p "Entrez une commande :" reponse	#on recupere la commande
    exec $reponse & > /dev/null #on execute la commande de manière asynchrone
	echo ${?}  # on affiche le code erreur de la commande executée.	
done
