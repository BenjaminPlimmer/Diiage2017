#!/bin/bash
#@AIM : Script de suivi de machine
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#24/01/2017 - Création du script
#

echo "Saisisez une valeur pour poursuivre:"
echo "1: Pour afficher la somme mémoire des IPC"
echo "2: Afficher et gerer les processus"
echo "3: Afficher un code retour de processus"
echo "4: Afficher les informations de charge systeme"

read value

if [ "$value" == "1" ]
then

        ipcs |awk '{ if ($5 ~ /^[0-9]*$/) SUM += $5} END { print "La somme mémoire des IPC est de " SUM/1024/1024 " Mo"}'
fi

if [ "$value" == "2" ]
then
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

fi

if [ "$value" == "3" ]
then
        name=""
        while [[ $name != "exit" ]]
        do
                echo "Saisir le processus :"
                read name
                #Affichage du resultat de la commande
                $name
                #Affichage du code retour
                echo "Le code retour de $name est ${?}"
        done
fi


if [ "$value" == "4" ]
then
        echo -e "--Ram libre--: " && free | awk 'FNR == 3 {print $4/($3+$4)*100}'
        echo "--Utilisation CPU--:"
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1"%"}'


fi
