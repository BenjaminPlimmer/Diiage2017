#!/bin/bash
#@AIM : Liste les processus et les processus enfants
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

# Verifie si le package psmisc pour utiliser la commande pstree est installé sur la machine (retourne ii)
result=$(dpkg -l | grep psmisc | cut -d ' ' -f1)

# Test si la commande result retourne ii
if [ "$result"="ii" ]
then
        echo -e ""
else
        echo -e "Installation de pstree"
        apt-get install psmisc
fi

echo -e "Arborescence des processus et des processus enfants (fork) : "
pstree