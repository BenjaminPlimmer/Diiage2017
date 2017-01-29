#!/bin/bash
#@AIM : Fail2Ban , script Bash implémentant un système de détection d'intrusion 
#@AIM : activité suspecte sur un serveur GNU/Linux via la surveillance "temps réel" des logs d'activité.
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none

#AIM : get last line of file
#PARAMS : [string] file
function getLastLine
{
    last=$(tail -1 $1)
}

#AIM : check if regex matches last line of file and increment nb if same capture 
#PARAMS : [string] regex , [string] line
function matchRegex
{
echo "$2"
echo "$1"
if [[ $2 =~ $1 ]]
then
	if [[ "$matched" = "${BASH_REMATCH[1]}" ]];then ((nb++));echo "i azeazeaze";fi
	matched="${BASH_REMATCH[1]}"
	echo "$matched"
fi
}

#AIM : Echo config file syntax
#PARAMS : NONE
function confFileSyntax
{
echo -e "\n#$configFile configuration file syntax\nfile=<file>\nregex=<regex>\naction=<action match>\ncount=<number of matching rex before doing action\n# match will be replace with extracted patern from regex\n"
}


#Start script

#config file location
configFile=actionOnModif.conf
#count variable
nb=1

#check if file exist and if correct syntax
if [ -f $configFile ]
then
	#get variables from the configuration file
	file=$(awk '$1 ~ /file=+/ {print $1}' $configFile)
	regex=$(grep "regex=" $configFile)
	action=$(grep "action=" $configFile)
	count=$(awk '$1 ~ /count=+/ {print $1}' $configFile)


	#format variables
	file=$(echo "${file/file=/}")
	regex=$(echo "${regex/regex=/}")
	action=$(echo "${action/action=/}")
	count=$(echo "${count/count=/}")
	
	#check if variables were find
	if [[ -z $file ]] || [[ -z $regex ]] || [[ -z $action ]]|| [[ -z $count ]]
	then
		echo "incorrect syntax $configFile"
		confFileSyntax
		exit 1
	fi
else
   echo "$configFile : file does not exist"
   echo "Please create $config file"
   confFileSyntax
   exit 1
fi

#monitor file modifications
while inotifywait -e modify "$file"
do
	
	getLastLine $file

	matchRegex $regex "$last"
	
	#only perfom the action if event happened the right number of times
	if [ "$nb" == "$count" ]
	then
		#replace the variable in the command
		command=$(echo "${action/match/"$matched"}")
		$command
		echo "executed: $command"
		nb=1
	fi
	
	echo "$nb"


done