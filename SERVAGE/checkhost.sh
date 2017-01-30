#!/bin/bash
#@AIM : Affiche l'état du système par catégorie en fonction des options choisies
#@AUTHORS : SERVAGE THOMAS
#@PARAMS : 
#		-OS
#		-mem
#		-net
#		-ipc
#		-disk
#		-proc
#		-help
#@MODIF : None




#AIM : Fonction permettant d'afficher un entête pour chaque option
#PARAMS : None 
#RETURN : None
function write_header(){
	local h="$@"
	echo "---------------------------------------------------------------"
	echo "     ${h}"
	echo "---------------------------------------------------------------"
}
#AIM : Fonction permettant d'afficher les informations du système 
#PARAMS : None 
#RETURN : None
function os_info()
{
        write_header " System information "
        echo "Operating system : $(uname -a)"
}
#AIM : Fonction permettant d'afficher les informations sur la mémoire utilisée
#PARAMS : None 
#RETURN : None
function mem_info()
{
        write_header " Free and used memory "
        free -m

    echo "*********************************"
        echo "*** Virtual memory statistics ***"
    echo "*********************************"
        vmstat
    echo "***********************************"
        echo "*** Top 5 memory eating process ***"
    echo "***********************************"
        ps auxf | sort -nr -k 4 | head -5
}

#AIM : Fonction permettant d'afficher les informations sur les IPCs
#PARAMS : None 
#RETURN : None
function ipc_info()
{
        write_header " Used memory by IPC "
        ipcs | awk '{ if ($5 ~ /^[0-9]*$/) sum+=$5;}END {print sum/1048576 " Mo"}'
}

#AIM : Fonction permettant d'afficher les connections entrantes/sortants 
#PARAMS : None 
#RETURN : None
function net_info()
{
        write_header=$(netstat -i | cut -d" " -f1 | egrep -v "^Kernel|Iface|lo")
        echo  " Network information "
        echo "Total network interfaces found : $(wc -w <<<${devices})"
        echo "*** IP Addresses Information ***"
        ip -4 address show
        echo "***********************"
        echo "*** Network routing ***"
        echo "***********************"
        netstat -nr
        echo "**************************************"
        echo "*** Interface traffic information ***"
        echo "**************************************"
        netstat -i
}
#AIM : Fonction permettant d'afficher l'utilisation du disque
#PARAMS : None 
#RETURN : None
function disk_info()
{
write_header " Disk information"
df -h
}
#AIM : Fonction permettant d'afficher les informations concernant les processus
#PARAMS : None 
#RETURN : None
function proc_info()
{
write_header "Process information"

echo "process zombie"
ps axo stat,ppid,pid,comm | grep -w defunct

echo "arborescence des processus"
if [ ! -e "/tmp/list.csv" ]
then
rm /tmp/list.csv
fi

currentlevel=0
# Fix le début de l'arborescence à 1
root='1'
list_proc
subtree 0 |more 
rm /tmp/list.csv
}
#AIM : Fonction permettant d'afficher l'aide sur l'utilisation du script
#PARAMS : None 
#RETURN : None
function help_info()
{
write_header "Help information"
echo " -os	; os info "
echo " -mem	; memory info "
echo " -net	; network info "
echo " -ipc	; ipc info "
echo " -disk	; disk info "
echo "-proc	;process info"
}


#AIM : Fonction permettant de faire un arborescence recursive des processus
#      et processus enfant à partir d'un fichier formaté
#      format du fichier : "PID:PPID"
#PARAMS : int[FIRST PID] 
#RETURN : None
function subtree ()
{
    while IFS=":" read enfant parent name
    do
        if [[ "$parent" == "$1" ]]; then
            for (( i = 0; i < $currentlevel; i++ )); do
                echo -e -n "|      "
            done
            echo -e "└------$enfant($name)"
            currentlevel=$((currentlevel+1))
            subtree $enfant
            currentlevel=$((currentlevel-1))
        fi
    done < /tmp/list.csv
}

function list_proc()
{
LIST=$(ls /proc/ | grep "[0-9]")

# Parcours la liste de processus dans /proc et stocke le PID, le nom 
# et le PPID dans des variables.
for i in $LIST; do
    NAME=$(grep "Name" /proc/$i/status 2>/dev/null | awk -F " " {'print $2'}) 
    IDP=$(grep "PPid" /proc/$i/status 2>/dev/null |awk -F " " {'print $2'})
    PID=$(grep -e "^Pid" /proc/$i/status 2>/dev/null |awk -F " " {'print $2'}) 
    echo "$PID:$IDP:$NAME" >> /tmp/list.csv
done
}


# Test les paramètres entrés
if [ $# -eq 0 ]
 then
	echo "pas d'argument"
	help_info
	exit 0
fi
if [ $# -ne 0 ]
then
	clear
	for var in "$@"
	 do
		if [ "$var" == "-os" ]
		then
			os_info
		fi
		if [ "$var" = "-mem" ]
		then
			mem_info
		fi
		if [ "$var" == "-net" ]
		then
    			net_info
		fi
		if [ "$var" == "-ipc" ]
		then
			ipc_info
		fi
		if [ "$var" == "-help" ]
		then
			help_info
		fi
		if [ "$var" == "-disk" ]
		then
			disk_info
		fi
		if [ "$var" == "-proc" ]
		then
			proc_info
		fi
	done
fi

exit 0
