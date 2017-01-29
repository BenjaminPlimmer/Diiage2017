#!/bin/bash
#@AIM : General Health check of a Linux Machine
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none

#AIM : Show tree from file (parent:enfant:name) 
#PARAMS : [INT] PID 
function CreateTree
{
	while IFS=":" read Enfant Parent Name
	do
		if [ "$Parent" == "$1" ] 
		then
			for (( i=0; i<$CurrentLevel; i++ ))
			do
				echo -e -n "|      "
			done
			echo -e "└------$Enfant($Name)"
			CurrentLevel=$((CurrentLevel+1))
			CreateTree $Enfant
			CurrentLevel=$((CurrentLevel-1))
		fi
	done < /tmp/info
}

#AIM : Show all process and their children
#PARAMS : none
function GetTree
{
	File=$(ls /proc/ | grep "[0-9]")

	#Save pid, ppid and name in file /tmp/info
	#File format pid:ppid:name
	for f in $File
	do
		Name=$(more /proc/$f/status 2>/dev/null | grep "Name" | awk -F " " {'print $2'}) 
		IdParent=$(more /proc/$f/status 2>/dev/null | grep "PPid" |awk -F " " {'print $2'})
		echo "$f:$IdParent:$Name" >> /tmp/info
	done

	CurrentLevel=0

	CreateTree 0

	rm /tmp/info
}


#AIM : Kill process
#PARAMS : none
function DeleteProcess
{
#kill process
while [[ $Kexit != 1 ]]
do
    read -p "Enter process ID to kill (type q to exit) ? : " id
	#check if input is empty
	if [[ -z "$id" ]]
	then
		continue
		
	else
		if [[ $id = "q" ]]
		then
			Kexit=1
		else	
			#check if id exist
			if [ -d "/proc/$id" ]
			then
				kill $id
			else
				echo "$id unknown"
			fi
	fi	fi
    
done
}

#AIM : Count number of bites used by ipcs
#PARAMS : none
function GetBitesIpcs
{
ipcsUsed=$(ipcs |awk  '$5 ~ /[0-9].*/ {sum+=$5}END {print sum/1024/1024 " MB"}')
echo -e "\n##IPCS##"
echo "Used"
echo "$ipcsUsed"
echo -e "\n##IPCS##"
}

#AIM : Get Memory Percent from free command
#PARAMS : none
function GetMemoryPercent
{
totalMemory=$(free -h |awk 'NR==2 {print $2}')
freeMemoryPercent=$(free |awk 'NR==2 {print $4/$2*100}')
echo -e "\n##Memory##"
echo "Total : Free"
echo "$totalMemory : $freeMemoryPercent %"
echo -e "##Memory##"

}

#AIM : Get Swap Percent from free command
#PARAMS : none
function GetSwapPercent
{
totalSwap=$(free -h |awk 'NR==4 {print $2}')
freeSwapPercent=$(free |awk 'NR==4 {print $4/$2*100}')
echo -e "\n##SWAP##"
echo "Total : Free"
echo "$totalSwap : $freePercent %"
echo -e "##SWAP##"
}

#AIM : Get Disk info from df command
#PARAMS : none
function GetDiskPercent
{
freeDiskPercent=$(df -h |awk ' NR > 1{print $1 " : "  $5 " : " $2}')
echo -e "\n##Disk usage##"
echo "$freeDiskPercent"
echo -e "##Disk usage##"
}

#AIM : Get top 3 process by memory usage from ps command
#PARAMS : none
function GetTopProcessMemory
{
ps aux --sort -rss |awk 'NR < 5 {print $1"\t"$2"\t" $4"\t"$11} '
}

#AIM : Summary of process state from /proc/
#PARAMS : none
function ProcessState
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
	# if ( $state==S ) 
	# then
		
	# done
	
	# Name=$(more /proc/$f/status 2>/dev/null | grep "Name" | awk -F " " {'print $2'}) 
	# IdParent=$(more /proc/$f/status 2>/dev/null | grep "PPid" |awk -F " " {'print $2'})
	# echo "$f:$IdParent:$Name" >> /tmp/info
done
total=$((running+sleeping+stopped+zombie))
echo -e "\n##Process state"
echo -e "Total \t Sleeping \t Stopped \t Running \t Zombie"
echo -e "$total \t $sleeping \t\t $stopped \t\t $running \t\t $zombie"
echo -e "##Process state"
}

#AIM : get hostname and ipAddress from ifconfig
#PARAMS : none
function HostInfo {
	echo -e "\n##Hostname##"
	echo "Fully qualified domain name : $(hostname -f)"
	ifconfig | awk 'BEGIN { FS = "\n"; RS = "" } { print $1 $2 }' | sed -e 's/ .*inet addr:/:/' -e 's/ .*//'
	echo -e "##Hostname##"
}

#AIM : List help with commands to type for minishell
#PARAMS : none
function ListCommands {
echo -e "##Minishell Help##\nEnter any system command\nhinfo (Basic host information)\npstate (Summary of process)"
echo -e "topp (Top 3 Process by Memory)\ndinfo (Disks info)\nsinfo (Swap info)\nminfo (Memory info)\nipcs (Ipcs info)\nkp (Delete Process)\nGetTree (list all process)"
echo -e "exit (to leave)"
}

#AIM : Change enter command to function name
#PARAMS : [string] command
function SimplifyCommands {
	echo $1
	case "$1" in
		hinfo)
			Command="HostInfo"
			;; 
		pstate)
			Command="ProcessState"
			;;
		topp)
			Command="GetTopProcessMemory"
			;;
		dinfo)
			Command="GetDiskPercent"
			;;
		sinfo)
			Command="GetSwapPercent"
			;;
		minfo)
			Command="GetMemoryPercent"
			;;
		ipcs)
			Command="GetBitesIpcs"
			;;
		kp)
			Command="DeleteProcess"
			;;
	esac
}

#Start script

HostInfo
ProcessState
GetMemoryPercent

echo "Type --help for mon info"
Exit=0
#AIM : minishell , execute command 

while [[ $Exit != 1 ]]
do
	read -p "minishell : " Command
	SimplifyCommands "$Command"
	#if empty continue
	if [[ -z "$Command" ]]; then continue; fi
	#show help
	if [[ "$Command" = "--help" ]]; then ListCommands ;continue; fi
	#exit script
	if [[ "$Command" = "exit" ]]
	then
		Exit=1
	else
		$Command 
		if [[ ! ${?} = 0 ]];then echo -e "Incorrect command\nType --help for mon info"; fi
	fi
done
