#!bin/bash
if [ $# -eq 0]
then
echo"le paramètre doit être le numéro de processus
pstree -p
else
pstree -p $1
fi

exit