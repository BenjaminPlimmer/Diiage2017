#!/bin/bash
# prendre en entré un fichier qui comprend des lignes comme :
#user:groupe:repertoire:repertoire globale:droit
#droit de parcourir le fichier qu'une seule fois

if [ $# -eq 0 ]
 then
        echo "pas d'argument"
        exit 0
fi
if [[ ! -f "$1" ]]; then
        echo -e "Le fichier $1 n'existe pas."
        exit
fi

declare -a util
        i=0
while IFS ":" user group dir globaldir droit
 do
        declare -a $user
        $user[0]=$user
        $user[1]=$group
        $user[2]=$dir
        $user[3]=$globaldir
        $user[4]=$droit
        $util[$i]=$user
        $i++
done

for j in ${util[*]} do
 if grep -q ${j[1]} /etc/group
    then
         echo "group exits"
        useradd ${j[0]} -d ${j[2]} -G ${j[1]}
    else
        addgroup ${j[1]}
        useradd ${j[0]} -d ${j[2]} -G ${j[1]}
    fi
done
for j in ${util[*]} do
        setfacl -m u:${j[0]}:${j[4] ${j[3]}
        getfacl ${j[3]}
done
exit 0


