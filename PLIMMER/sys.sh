#!/bin/bash
#@AIM : General Health check of a Linux Machine
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none

#AIM : Get Disk info from d/proc/mount
#PARAMS : none
function getDisk
{
	disks=$( awk '$1 ~/^\/.*/ {print $1 " : " $2 }' /proc/mounts)

	echo "\n##Disks##"
	echo "Disk  : Monté sur"
	echo "$disks"
	echo "####"
}

#AIM : Get process state from /proc
#PARAMS : none
function processState
{

	File=$(ls /proc/ | grep "[0-9]")

	sleeping=0
	zombie=0
	running=0
	stopped=0

	#Save pid, ppid and name in file /tmp/info
	#File format pid:ppid:name
	for f in $File
	do
		
		state=$(awk 'NR==2{print $2'} /proc/$f/status 2>/dev/null)
		case "$state" in
			S)
				((sleeping++))
				;; 
			T)
				((stopped++))
				;;
			R)
				((running++))
				;;
			Z)
				((zombie++))
				;;
		esac
		((total++))
	done

	total=$((running+sleeping+stopped+zombie))
	echo -e "\n##Process state##"
	echo -e "Total \t Sleeping \t Stopped \t Running \t Zombie"
	echo -e "$total \t $sleeping \t\t $stopped \t\t $running \t\t $zombie"
	echo -e "####"
}

#AIM : Get total disk space
#PARAMS : none
function totalDiskSpace
{
	echo -e "\n##Total Disk Space##"
	df |awk  '$2 ~ /[0-9].*/ {sum+=$2}END {print sum/1024/1024 " GB"}'
	echo "####"
}

#AIM : Get top process from ps
#PARAMS : none
function topProcess {
	echo -e "\n##Top process##"
	ps aux --sort=-%cpu | head -n 2
	echo "####"
}

#AIM : Get ipc
#PARAMS : none
function getIpcs {
	echo -e "\n##IPC##"
	ipcs
echo "####"
}

#AIM : Get uptime
#PARAMS : none
function getUptime 
{
	echo -e "\n##Uptime##"
	uptime -p 
	echo "####"
}

#AIM : Get inode usage from df
#PARAMS : none
function getInode 
{
	echo -e "\n##Inode Usage##"
	echo "Monté sur : IUTIL%"
	df -i | awk 'NR>1 {print $6 " : "  $5 }'
	echo "####"

}

#start scipt
getInode
getUptime
getIpcs
topProcess
totalDiskSpace
processState
getDisk


