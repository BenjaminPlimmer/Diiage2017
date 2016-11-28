#!/bin/bash
# AIM: script listant les processus ainsi que leurs enfants
# AUTHORS: Jérémy BERNARD
#PARAMS: aucun paramètre
#MODIF:

#recherche des processus en utilisant une bouche for
for P in $(seq 1 32618); do
   [ -d "/proc/$P" ] || continue
   echo "$P: $(cat /proc/$P/cmdline 2>/dev/null |sed 's/\x00/ /g')"
# recherche des PPID par processus
   grep -E PPid /proc/$P/status
# Mettre en place l'arborescence des processus en joignant les PPID avec les PID
# Je n'ai pas trouvé la syntaxe pour le faire
done
