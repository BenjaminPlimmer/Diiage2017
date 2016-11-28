#!/bin/bash
#@AIM : Show all process and their children
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : None

FILE=$(ls /proc/ | grep "[0-9]")

# Save pid and ppids in file /tmp/info
for f in $FILE; do
   NAME=$(more /proc/$i/status 2>/dev/null | grep "Name" | awk -F " " {'print $2'}) 
   IDP=$(more /proc/$i/status 2>/dev/null | grep "PPid" |awk -F " " {'print $2'}) 
   echo "$f:$IDP" >> /tmp/info
done

currentlevel=0

#AIM : Show tree from file (parent;enfant) || Stolen from internet
#PARAMS : [INT] PID racine
function subtree
{
   while IFS=":" read enfant parent
   do
      if [ "$parent" == "$1" ] 
      then
         for (( i=0; i<$currentlevel; i++ ))
         do
            echo -e -n "|      "
         done
         echo -e "└------$enfant"
	 currentlevel=$((currentlevel+1))
	 subtree $enfant
	 currentlevel=$((currentlevel-1))
      fi
   done < /tmp/info
}

subtree 1

rm /tmp/info
