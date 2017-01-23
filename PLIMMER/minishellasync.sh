#!/bin/bash
#@AIM : minishell , execute command and show return code
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none


#AIM : execute command
#PARAMS : [string] command
function execute
{
	$1
	echo -e "\nreturn code for $1 : ${?}"	
}

#Start script

Exit=0
while [[ $Exit != 1 ]]
do
		
	read -p "minishell : (type exit to leave)" Command
	if [[ -z "$Command" ]]; then continue; fi
	if [[ "$Command" = "exit" ]]
	then
		Exit=1
	else
		#execute function in background
		execute "$Command" &
	fi
done

#kill all child process
kill -- -$$

exit 0


