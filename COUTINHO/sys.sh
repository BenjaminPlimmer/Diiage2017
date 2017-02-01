#!/bin/bash
#@AIM : Affiche différentes informations sur le système
#@AUTHORS : Nicolas Coutinho
#@PARAMS : None
#@MODIF : None
function afficheMenu ()
{
        echo -e "\n1 - Disques montés\n"
        echo -e "2 - Espace disque total disponible\n"
        echo -e "3 - Nombre de processus en cours\n"
        echo -e "4 - IPC ouverts sur la machine\n"
        echo -e "5 - Processus le plus groumand en CPU\n"
        echo -e "6 - Uptime\n"
        #echo -e "7 - Taux remplissage des tables d'Inodes\n"
}

#AIM : Fonction permettant d'afficher les disques montés
#PARAMS : None
#RETURN : None
function diskMountAndSpace()
{
        df -h
}

#AIM : Fonction permettant d'afficher les ipcs
#PARAMS : None
#RETURN : None
function ipc()
{
        ipcs
}

#AIM : Fonction permettant d'afficher l'uptime
#PARAMS : None
#RETURN : None
function upTime()
{
        uptime
}

#AIM : Fonction permettant d'afficher le processus le plus groumand en CPU
#PARAMS : None
#RETURN : None
function processCPU()
{
        ps aux --sort=-%cpu | awk 'NR==1{print $2,$3,$11}NR>1{if($3!=0.0) print $2,$3,$11}'
}

#AIM : Fonction permettant d'afficher le nombre de processus
#PARAMS : None
#RETURN : None
function nbProc()
{
        echo -e "$(ps -u "$(echo $(w -h | cut -d ' ' -f1 | sort -u))" o user= | sort | uniq -c |$
}


while [ "$input" != "q" ]
do
        afficheMenu
        read -p "Action: " input
        case $input  in
                "1") diskMountAndSpace ;;
                "2") diskMountAndSpace ;;
                "3") nbProc ;;
                "4") ipc ;;
                "5") processCPU ;;
                "6") upTime ;;
                #"7") inodes ;;
                "q") exit ;;
                *) echo -e "\t$input n'est pas une valeur comprise" ;;
        esac
done
