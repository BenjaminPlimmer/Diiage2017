#!/bin/bash
#@AIM : Execute une commande et retourne son code
#@AUTHORS : PETIT Alexandre
#@PARAMS : None
#@MODIF : None

function cmd
{
        $1
        res=$?

        if [ $res != "0" ]
        then
                echo "Code erreur $res"
        fi
}

shell="a"
while [ "$shell" != "q" ]
do
        read -p "Taper une commande : " shell

        if [ "$shell" != "q" ]
        then
                cmd "$shell" &

        fi
done