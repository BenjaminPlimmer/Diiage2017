#!/bin/bash
#@AIM : Affiche les informations sur le système
#@AUTHORS : SERVAGE THOMAS
#@PARAMS : 
#@MODIF : None


function write_header(){
	local h="$@"
	echo "---------------------------------------------------------------"
	echo "     ${h}"
	echo "---------------------------------------------------------------"
}

function disk_info()
{
write_header " Disk information"
fdisk -l | awk '{ if ($1 ~ /^\//) print $1}'

}

function disk_space()
{
write_header " espace disque disponible"
df | awk '{ if ($1 ~ /^\//) sum+=$4;}END {print sum/1048576 " Go"}'
}

function nb_proc()
{
write_header "nombre de processus"
ps -aux | wc -l
}

function ipc()
{
write_header "IPC"
ipcs
}


function proc_cpu_max()
{
write_header "Processus le plus gourmand en CPU"
ps -aux | awk '{ if ($3 != "0.0" && $3 ~ /^[0-9/]) print $11}'

}

function up()
{
write_header "Uptime"
 uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/' 
}
disk_info

disk_space

nb_proc

ipc

proc_cpu_max

up


exit 0