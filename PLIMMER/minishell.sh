#!/bin/bash
#@AIM : minishell , execute command and show return code
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none

Exit=0
while [[ $Exit != 1 ]]
do
	read -p "minishell : (type exit to leave) " Command
	if [[ "$Command" = "exit" ]]
	then
		Exit=1
	else
		#execute command and redirect all output to /dev/null
		$Command >/dev/null 2>&1
		echo "return code" ${?}
	fi
done

exit 0

