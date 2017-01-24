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
while [[ $Exit != 1 ]]
do
    read -p "Enter process ID to kill ? : enter q to exit" id
	#check if input is empty
	if [[ -z "$id" ]]
	then
		continue
		
	else
		if [[ $id = "q" ]]
		then
			Exit=1
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
ipcs |awk  '$5 ~ /[0-9].*/ {sum+=$5}END {print sum/1024/1024 " MB"}'
}

function GetMemoryPercent
{
freePercent=$(free |awk 'NR==2 {print $4/$2*100}')
echo "Free memory : $freePercent %"
}

function GetSwapPercent
{
freePercent=$(free |awk 'NR==4 {print $4/$2*100}')
echo "Free swap : $freePercent %"
}

function GetDiskPercent
{
freePercent=$(df |awk ' NR > 1{print $1 " : "  $5}')
echo $freePercent
}

function GetTopProcessMemory
{
aux --sort -rss |awk 'NR < 5 {print $1"\t"$2"\t" $4"\t"$11} '
}

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
echo -e "Total \t Sleeping \t Stopped \t Running \t Zombie"
echo -e "$total \t $sleeping \t\t $stopped \t\t $running \t\t $zombie"


}

#Start script

ProcessState