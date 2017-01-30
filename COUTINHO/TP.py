def mafunc (var1=""):
        if var1 == "":
                print("Pas de parametre")
        else:
                for i in range (1,10):
                        print (int(var1) * i)
maVar = input ("NB : ")
mafunc(maVar)
