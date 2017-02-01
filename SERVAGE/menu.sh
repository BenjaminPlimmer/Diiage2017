
#!/bin/bash


function menu()
{

        echo "1 - Verifier l existence d'un utilisateur "
        echo "2 - Connaitre l UID d un utilisateur "
        echo "q - Quitter"
}
function user()
{
        echo "rentrer le nom de l'utilisateur"
        read  utilisateur

        if getent passwd $utilisateur > /dev/null 2>&1;
        then
    echo "utilisateur $utilisateur existe"
        else
    echo "utilisateur $utilisateur inconnu"
        fi
}
function uid()
{
        echo "rentrer le nom de l'utilisateur "
        read userUid
        test= id -u $userUid
        if [$test =~ /[0-9]*$/ ]
        then
                echo "utilisateur $userUid a pour uid $test"
        fi
        echo "test"
}

while [ "$param" != "q" ]
do
        menu
        read param
        if [ "$param" == "1" ]
        then
                user
        fi
        if [ "$param" == "2" ]
        then
                uid
        fi
done
exit 0


