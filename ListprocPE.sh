#!/bin/sh


# Affichage de la liste des processus sous forme d'arborescence , en ajoutant les liens de parent�s Parent/Enfant , puis en sp�cifiant via les options "p" l'id de processus et "u" l'utilisateur ayant lanc� le proc.

pstree -up | less
