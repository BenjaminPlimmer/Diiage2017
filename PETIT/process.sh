#!/bin/bash
#@AIM : Affichage des processus parents, enfants et kill du process
#@AUTHORS :
#   - Alexandre PETIT
#@PARAMS :
#@MODIF :

function tree
{
        # Affichage de l'arbre
        while IFS=":" read id parent nom
        do
	    #Condition sur le parent
            if [ "$parent" == "$1" ]
            then
                for (( i=0; i<$currentLevel; i++ ))
                do
                    echo -e -n "|      "
                    done
                    echo -e "└------$id($nom)"
                    currentLevel=$((currentLevel+1))
                    tree $id
                    currentLevel=$((currentLevel-1))
                fi
        done < /tmp/tmptree
}

# Listing des process contenant 0 à 9
for i in $(ls /proc | grep '[0-9]$')
do
    #Stockage des données
    id=$(grep -w "Pid:" /proc/$i/status  2>/dev/null | awk -F " " {'print $2'})
    parent=$(grep -w "PPid:" /proc/$i/status 2>/dev/null | awk -F " " {'print $2'})
    nom=$(grep -w "Name:" /proc/$i/status 2>/dev/null| awk -F " " {'print $2'})
	
    #Stockage des données dans le fichier tmptree
    echo "$i:$parent:$nom" >> /tmp/tmptree	
done

currentLevel=0
tree 0

#Suppression du tmptree
rm /tmp/tmptree

#Kill du processus souhaité
read -p "Saisir le processus à tuer, sinon <exit> : " id

#Test si id égal exit
if [ "$id" == "exit" ]
then
    #Le script s'arrête
    exit
else
	#On kill le process
	kill $id
fi
