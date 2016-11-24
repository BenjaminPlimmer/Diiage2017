#!/bin/sh


# Affichage de la liste des processus sous forme d'arborescence , en ajoutant les liens de parentés Parent/Enfant , puis en spécifiant via les options "p" l'id de processus et "u" l'utilisateur ayant lancé le proc.

pstree -up | less
