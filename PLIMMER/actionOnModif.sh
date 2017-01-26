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

#AIM : check regex
#PARAMS : [string] regex , [string] line
function matchRegex
{
[[ $2 =~ $1 ]] && ((nb++))
matched="${BASH_REMATCH[1]}"
}


#Start script

nb=0
#get variables from the configuration file
file=$(awk '$1 ~ /file=+/ {print $1}' actionOnModif.conf)
regex=$(grep "regex=" actionOnModif.conf)
action=$(grep "action=" actionOnModif.conf)
count=$(awk '$1 ~ /count=+/ {print $1}' actionOnModif.conf)



file=$(echo "${file/file=/}")
regex=$(echo "${regex/regex=/}")
action=$(echo "${action/action=/}")
count=$(echo "${count/count=/}")


while inotifywait -e modify "$file"
do
	getLastLine $file

	matchRegex $regex $last
	#only perfom the action if event happen the right nomber of times
	if [ "$nb" == "$count" ]
	then
		#replace the variable in the command
		command=$(echo "${action/match/"$matched"}")
		$command
		echo "executed: $command"
		nb=0
	fi
	
	echo "$nb"
	echo "$matched"

done