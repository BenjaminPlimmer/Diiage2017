def addi (nb1, nb2):
        total=nb1+nb2
        print (" addition")
        print total
        return 0

def multi (nb1):
        multiple=[]
        i=1
        print ("\n multiplication")
        while i <= 10 :
                multiple.append(i*nb1)
                i+=1

        for y,val in enumerate(multiple):
                print (val)

        return 0

addi(2,3)
multi(3)













