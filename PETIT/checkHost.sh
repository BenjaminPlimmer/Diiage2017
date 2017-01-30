#!/bin/bash
#@AIM : Script de vérification du système
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None


######################################################
#Déclaration des fonctions
######################################################
#Variables pour monitoring
function Stockage 
{
	hostnam=$(hostname)
	uptim=$(uptime | awk '{print $3}')
	total=$(free -h | awk 'NR==2 {print $2}') 
	used=$(free -h | awk 'NR==2 {print $3}')
	dispo=$(free -h | awk 'NR==2 {print $4}')
	ddutil=$(df -h | awk {'print $1 "" $5'})
	proc=$(ps -o %cpu |awk 'NR==2')
}

#Process
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

function killProcess
{
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
    Menu    
else
    #On kill le process
    kill $id
    Menu
fi
}

#Affichage des données
function Affichage
{
	echo "______________________________________________"

	echo "Serveur :" $hostnam
	echo "Up time :" $uptim
	echo ""
	echo "CPU : "
	echo "Utilisation Processeur (%) : " $proc
	echo ""
	echo "RAM : "
	echo "Ram totale : " $total
	echo "Ram utilisée : " $used
	echo "Ram disponible : " $dispo
	echo ""
	echo "DD :"
	echo "Disque (utilisation en %) : "
	df -h | awk 'NR>1{print $1 ": " $5}'
	echo "______________________________________________"
}

#Affichage du menu
function Menu 
{
	read -p "Que faire ? <a>: Actualiser ; <p> : Liste & Kill Process ; <q>: Quitter : " selec

	case "$selec" in
		a)  Attente
			Stockage
			Affichage
			Menu
		;;

		p)  killProcess
		;;
		
		q)  exit
		;; 

		*)  echo "Commande introuvable"
		    Menu
		;;
	esac
}

#Transition de 3 secondes
function Attente
{
	echo "En cours ."
	for ((i=1; i<4; i++))
	do
		echo "."
		sleep 1
	done
}
######################################################
#Appel des fonctions
######################################################
Stockage
Affichage
Menu