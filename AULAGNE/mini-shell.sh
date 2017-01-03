#!/bin/bash

read -p "Entrez une commande :" reponse
exec $reponse | echo ${?}

