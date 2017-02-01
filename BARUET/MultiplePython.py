def AddMultip(N=" ") :
 if N==" " :
  print("rentrer une valeur.")
 elif type(N)==int :
  for i in range (1,11) :
   print(N*i)

 else :
  print("rentrer un entier.")

Number = input ("Donner un chiffre : ")
AddMultip(Number)
