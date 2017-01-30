#!/usr/bin/env python3
#@AIM : Script d'addition de 2 params et affichage d'une table de multiplication
#@AUTHORS : PETIT Alexandre
#@PARAMS : Param1, Param2
#@MODIF : None

#Fonction addition qui prend en compte 2 nombres 
def addition(param1,param2):
   result=param1+param2
   print("Addition de "+str(param1)+" et "+str(param2)+ " = : " +str(result))
   return result

addition(1,3)

#Fonction multiplication qui prend en compte 1 nombre
def multipli(param1):
   for i in range(1,120):
      result=param1*i
      print("Table de multiplication de "+str(param1)+" = : "+str(result))
      #return result
multipli(5)