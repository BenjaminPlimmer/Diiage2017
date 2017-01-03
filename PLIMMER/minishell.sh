#!/bin/bash
#@AIM : minishell , execute command and show return code
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none

Exit=0
while [[ $Exit != 1 ]]
do
	read -p "minishell : (press enter to leave) " Command
	if [[ -z "$Command" ]]
	then
		Exit=1
	else
		$Command $1>/dev/null
		echo ${?}
	fi
done


