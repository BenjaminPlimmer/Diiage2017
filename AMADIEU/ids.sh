#!/bin/bash
#@AIM : implémentant un système de détection d'intrusion /
# activité suspecte sur un serveur GNU/Linux via la surveillance "temps réel"
# des logs d'activité
#@AUTHORS : AMADIEU Romain
#@PARAMS : None
#@MODIF : None

inotifywait -m -r -e modify /tmp/fic.txt
