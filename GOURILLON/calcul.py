#!/usr/bin/env python -V
#@AIM : Table de multiplication
#@AUTHORS :
#   - Nicolas GOURILLON
#@PARAMS :
#   - Aucun paramètres
#@MODIF :
#30/01/2017 - Création du script
#

def mafonction (param1=" ",param2=" "):
        result=(param1+param2)
        print (result)

def fonctiontable(nombre=""):
        print ("Table de multiplication de:",nombre)
        for i in range (1,20):
                print ("|",nombre*i,"|")
                print ("-------")

#nb1 = input("Merci de saisir le premier nombre : ")
#nb2 = input("Merci de saisir le deuxieme nombre : ")

#mafonction(nb1,nb2)


nb = input("Pour avoir une table de multiplication, merci de saisir un nombre : ")
fonctiontable(int(nb))
