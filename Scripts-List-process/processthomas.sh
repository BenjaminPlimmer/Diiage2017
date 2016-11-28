#!bin/bash
#@AIM		:Afficher la liste des processus avec leurs enfants/parents
#@AUTHORS 	:THOMAS SERVAGE
#@PARAMS	:
#@MODIFS	:

#VÃ©rifie que l'appel du script contient un argument
if [ $# -eq 0 ]
then
	print "le paramÃ¨tre doit Ãªtre le numÃ©ro de processus"
	pstree -p
else
	pstree -p $1
fi
exit


