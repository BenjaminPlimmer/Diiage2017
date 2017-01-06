#!/bin/sh
#AIM : Analyse intrusion SSH 
#AUTHORS :   AULAGNE Jérôme
#PARAMS : 
#MODIF : en cours

#AIM : 
#PARAMS : 

inotifywait -m -e modify /var/log/auth.log | while read event file
do
   if tail -n1 /var/log/auth.log | grep failure
   then
       echo "ouiiiiiii"
   fi
done
