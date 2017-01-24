#!/bin/bash
#@AIM : Tableau de bord état du système
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

clear 

#Déclarations des variables
# ENTETERAM=$(free -h | awk 'NR==1')
# RAM=$(free -h | awk 'NR==2')
# BUFFERS=$(free -h | awk 'NR==3')
# SWAP=$(free -h | awk 'NR==4')
FREERAM=$(free | awk 'NR==2 {print $4/$2 * 100.0}')
USEDRAM=$(free | awk 'NR==2 {print $3/$2 * 100.0}')
TOTALERAM=$(free -h | awk 'NR==2 {print $2}')
RESET=$(tput sgr0)

#AIM : Fonction saut de ligne
#PARAMS : None 
#RETURN : None
function saut () {
	echo ""
}

#AIM : Fonction affiche Header
#PARAMS : None 
#RETURN : Header présentation
function printHeader () {
	echo -e "#######################"
	echo -e "#    CHECK HEALTH     #"
	echo -e "#######################"
}

#AIM : Fonction calcule somme mémoire utilisé par les IPCS
#PARAMS : None 
#RETURN : Totale de la mémoire utilisé par les ipcs en MB
function ipcSum () {
	ipcs -m | awk 'NR > 3 {sum += $5} END {print sum/1024/1024 " MB"}'
}

#AIM : Fonction affiche le 4 des processus trié par %MEM
#PARAMS : None 
#RETURN : Affiche le 4 des processus trié par %MEM
function getCPU () {
	ps aux --sort -rss | awk 'NR < 6 {print $1 "\t"$2 "\t"$3 "\t"$4 "\t"$8 "\t"$11}'
}

function getZombie () {
	ps aux | awk '"[Zz]" ~ $8 { printf("%s, PID = %d\n", $8, $2); }'
}

#AIM : Fonction propose de kill des processus si la RAM utlisé est supérieur à 80%
#PARAMS : None 
#RETURN : Affiche 4 top CPU par mémoire utilisé
function killCPU () {
	if [[ $USEDRAM > 80 ]]; then
		read -p "$USEDRAM'%' de la mémoire est utilisé, supprimer des processus ? [y/n] " REP
		if [[ "$REP" = "y" ]]; then
			while [[ "$REP" != "q" ]]; do
				read -p "Processus à tuer ? (q pour quitter)" REP
				if [[ "$REP" != "q" ]]; then
					kill $REP
				else
					exit
				fi
			done
		else 
			exit
		fi
	else 
		exit
	fi
}

#AIM : Fonction propose de kill des processus zombie sil il y en a si la RAM utlisé est supérieur à 80%
#PARAMS : None 
#RETURN : Affiche 4 top CPU par mémoire utilisé
function killZombie () {
		read -p "Des processus zombie on été detecté, supprimer les processus ? [y/n] " REP
		if [[ "$REP" = "y" ]]; then
			while [[ "$REP" != "q" ]]; do
				read -p "Processus à tuer ? (q pour quitter)" REP
				if [[ "$REP" != "q" ]]; then
					kill $REP
				else
					echo "Veuillez relancer le scan."
					exit
				fi
			done
		else 
			exit
		fi
}

#AIM : Fonction affiche la RAM Totale/Disponible/Utilisé
#PARAMS : None 
#RETURN : Affiche mémoire totale, disponible et utilisé (affiche valeur en rouge ou vert selon la charge)
function printRAM () {
	if [[ $USEDRAM > 80 ]]; then
		echo -e "RAM : "
		echo -e "Mémoire totale : $TOTALERAM"
		echo -e "Mémoire disponible :" '\E[31m'$FREERAM'%' $RESET
		echo -e "Mémoire utilisé :" '\E[31m'$USEDRAM'%' $RESET
		saut
	else
		echo -e "RAM : "
		echo -e "Mémoire totale : $TOTALERAM"
		echo -e "Mémoire disponible :" '\E[32m'$FREERAM'%' $RESET
		echo -e "Mémoire utilisé :" '\E[32m'$USEDRAM'%' $RESET
		saut
	fi
}

#AIM : Fonction affiche la somme utilisation IPCS
#PARAMS : None 
#RETURN : Affiche la somme utilisation IPCS
function printIpcsSum () {
	echo -e "IPCS : "
	echo -e -n "Mémoire utilisé par les ipcs : "; ipcSum
	saut
}

#AIM : Fonction affiche le nom d'hôte
#PARAMS : None 
#RETURN : Affiche nom d'hôte
function printHostame () {
	HOSTNAME=$(hostname)
	echo -e "Nom du serveur : $HOSTNAME"
	saut
}

#AIM : Fonction affiche 4 top CPU par mémoire utilisé
#PARAMS : None 
#RETURN : Affiche 4 top CPU par mémoire utilisé
function printCPU () {
	echo -e "CPU :"
	echo -e "TOP 4 CPU %MEM :"
	getCPU
	saut
}

#AIM : Fonction affiche le nombre de zombie sur le serveur
# et affiche les processus zombie
#PARAMS : None 
#RETURN : Affiche le nombre de zombie ou zombie + liste zombie
function printZombie () {
	COUNT=$(ps aux | awk '"[Zz]" ~ $8 {count++} END { printf count "\n"}')
	if [[ -z $COUNT  ]]; then
		echo "Il y a 0 zombie"
		saut
	else
		echo "Il y a $COUNT"
		getZombie
		killZombie
		saut
	fi
}

printHeader

printHostame

printRAM

printCPU

printZombie

printIpcsSum

killCPU

$RESET