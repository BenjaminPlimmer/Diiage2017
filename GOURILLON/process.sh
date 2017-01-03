#!/bin/bash
#@AIM : Afficher les processus et leurs enfants sous forme d'arborescence,
# trier par PID, avec les arguments de commande.
#@AUTHORS :
#   - Nicolas GOURILLON
#       - Florian MERLE
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#12/2016 - Changement de la mise en forme
#01/2017 - Modification affichage arbre

function subtree
{
        # Affiche un arbre à partir du noeud passé en argument

        while IFS=";" read pid ppid name
        do
                #echo "test $enfant ; $parent"
                if [ "$ppid" == "$1" ] # Cherche et affiche les enfants du noeud actuel
                then
                        for (( i=0; i<$currentlevel; i++ ))
                        do
                                echo -e -n "|      "
                        done
                        echo -e "└------$pid($name)"
                        currentlevel=$((currentlevel+1))
                        subtree $pid
                        currentlevel=$((currentlevel-1))
                fi
        done < /tmp/listproc
}

# Pour chacun des élements dans /proc analyser chacun des nom de 0 à 9
for i in $(ls /proc | grep '[0-9]$')
   do
                #Conserver valeur PPID, PID, et Name du PID
        pid=$(grep -w "Pid:" /proc/$i/status  2>/dev/null | awk -F " " '{print $2}')
        ppid=$(grep -w "PPid:" /proc/$i/status 2>/dev/null | awk -F " " '{print $2}')
        name=$(grep -w "Name:" /proc/$i/status 2>/dev/null| awk -F " " '{print $2}')
        echo $i';'$ppid';'$name >>/tmp/listproc
done
currentlevel=0
#root='1'

subtree 0
rm /tmp/listproc

echo "Pour tuer un processus merci de rentrer son pid, pour quitter taper: 'quit' "
read kill

if [ "$kill" == "quit" ]
then 
        echo "Sortie du script"
        exit
else
kill -9 $kill
fi
