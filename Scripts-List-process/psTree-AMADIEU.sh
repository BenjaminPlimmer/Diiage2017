#!/bin/bash

result=$(dpkg -l | grep psmisc | cut -d ' ' -f1)

if [ "$result"="ii" ]
then
        echo -e ""
else
        echo -e "Installation de pstree"
        apt-get install psmisc
fi

echo -e "Arborescence des processus et des processus enfants (fork) : "
pstree
