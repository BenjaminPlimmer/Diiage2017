#!/bin/bash
#@AIM : Script affichant diverses informations sur le système
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None




# Déclaratin des variables
DISKS=$(mount | grep /dev/sd | cut -d " " -f 1)


#AIM : Saut de ligne
#PARAMS : None 
#RETURN : Saut de ligne
function saut() {
	echo -e ""
}

#AIM : Fonction permettant d'afficher les disques montés sur le système
#PARAMS : None 
#RETURN : Affiche les disques montés
function printDisks() {
	echo -e "Disque montés : "
	echo -e "$DISKS"
	saut
}

#AIM : Fonction permettant d'afficher l'espace disque totale dispo des disques montés
#PARAMS : None 
#RETURN : Affiche l'espaces totale dispo des disques montés
function printTotalSpace() {
	echo "TOTALE DISKS :"
	for d in $DISKS
	do
		TOTALDISK=$(df -h | grep "$d" | awk '{print $4}')
		echo "$d : $TOTALDISK"
	done
	saut
}

#AIM : Fonction permettant d'afficher les processus en cours d'exécutions sur le système
#PARAMS : None 
#RETURN : Affiche le nombre de processus en cours d'exécution (R/R+)
function printNbProcess() {
	NBPROCESS=$(ps r | awk 'NR > 1' | wc -l)
	echo "Nombre de processus en cours d'éxecution (Etat R) : $NBPROCESS"
	saut
}

#AIM : Fonction permettant d'afficher le process consomment le plus de CPU
#PARAMS : None 
#RETURN : Affiche le processu qui consomme le plus de CPU
function printTopCPU() {
	FIRST=$(ps aux --sort=%cpu | tail -n1)
	echo "Processus le plus gourmand en CPU : "
	echo "$FIRST"
	saut
}

#AIM : Fonction permettant d'afficher les disques montés sur le système
#PARAMS : None 
#RETURN : Affiche les disques montés
function printIpcs() {
	echo "IPCS : "
	ipcs
	saut
}

#AIM : Fonction permettant d'afficher le temps 
#PARAMS : None 
#RETURN : Affiche le uptime
function printUptime() {
	UPTIME=$(uptime -p)
	echo "UPTIME : "
	echo "$UPTIME"
	saut
}

#AIM : Fonction permettant d'afficher es inodes
#PARAMS : None 
#RETURN : Affiche les inodes
function printTotalInodes() {
	echo "Totale Inodes (%) :"
	INODES=$(mount | grep /dev/sd | cut -d " " -f 1)
	for i in $INODES
	do
		TOTALINODES=$(df -h | grep "$i" | awk '{print $5}')
		echo "$i : $TOTALINODES"
	done
	saut
}

clear
echo "################"
echo "#    $0    #"
echo "################"
saut

printDisks
printTotalSpace
printNbProcess
printIpcs
printTopCPU
printUptime
printTotalInodes