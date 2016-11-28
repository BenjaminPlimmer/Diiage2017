#!/bin/bash
#@AIM : Afficher les processus et leurs enfants sous forme d'arborescence,
# trier par PID, avec les arguments de commande.
#@AUTHORS :
#   - Nicolas GOURILLON
#   - Florian MERLE
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#   - Changement de la mise en forme

# Pour chacun des élements dans /proc analyser chacun des nom de 0 à 9
for i in $(ls /proc | grep '[0-9]$')
   do
                #Conserver valeur PPID, PID, et Name du PID
        pid=$(grep -w "Pid:" /proc/$i/status  2>/dev/null | awk -F " " '{print $2}')
        ppid=$(grep -w "PPid:" /proc/$i/status 2>/dev/null | awk -F " " '{print $2}')
        name=$(grep -w "Name:" /proc/$i/status 2>/dev/null| awk -F " " '{print $2}')
        echo $pid';'$ppid >>/root/listproc
done


currentlevel=0
root='1'
function subtree
{

        # Affiche un arbre à partir du noeud passé en argument

        while IFS=";" read ppid pid
        do
                #echo "test $enfant ; $parent"
                if [ "$pid" == "$1" ] # Cherche et affiche les enfants du noeud actuel
                then
                        for (( i=0; i<$currentlevel; i++ ))
                        do
                                echo -e -n "|      "
                        done
                        echo -e "└------$ppid"
                        currentlevel=$((currentlevel+1))
                        subtree $ppid
                        currentlevel=$((currentlevel-1))
                fi
        done < listproc
}
subtree 1
rm /root/listproc
