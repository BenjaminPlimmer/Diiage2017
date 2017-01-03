#!/bin/bash
#@AIM : minishell , execute command and show return code
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none

#AIM : execute command
#PARAMS : [string] command
function execute
{
		$1 1>/dev/null 
		echo -e "$1 : ${?}"
}

Exit=0
while [[ $Exit != 1 ]]
do
	read -p "minishell : (press enter to leave) " Command
	if [[ -z "$Command" ]]
	then
		Exit=1
	else
		execute "$Command" &
	fi
done


