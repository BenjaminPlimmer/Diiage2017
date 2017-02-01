#!/bin/bash
#@AIM : Script d'affichage d'informations systèmes
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None

function Stockage 
{
disk=$(df -h | awk 'NR>1{print $1}')
ddFree=$(df |awk -F " " 'NR >1 {SUM+=$4} END{print SUM/1024}')
listProc=$(ps aux | wc -l)
ipcOpen=$(ipcs)
procCPU=$(ps aux | sort -rnk 3 | head -n 1)
uptim=$(uptime | awk '{print $3 $4}')
}


function Affichage
{
echo "#################################################################"
echo "Disque montés : $disk"
echo "#################################################################"
echo "Espace disque total disponible (Mo) : $ddFree"
echo "#################################################################"
echo "Nombre de processus en cours : $listProc"
echo "#################################################################"
echo "Ipc ouverts : $ipcOpen"
echo "#################################################################"
echo "Processus le plus gourmand en CPU : $procCPU"
echo "#################################################################"
echo "Uptime : $uptim"
echo "#################################################################"
}

Stockage
Affichage