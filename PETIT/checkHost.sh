#!/bin/bash
#@AIM : Script de vérification du système
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None


######################################################
#Déclaration des fonctions
######################################################
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
	read -p "Que faire ? <a>: Actualiser ; <q>: Quitter : " selec

	case "$selec" in
		a)  Attente
			Stockage
			Affichage
			Menu
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