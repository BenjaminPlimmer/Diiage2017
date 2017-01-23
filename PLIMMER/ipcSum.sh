#!/bin/bash
#@AIM : Count number of bites used by ipcs
#@AUTHORS : Benjamin PLIMMER
#@PARAMS : none


ipcs |awk  '$5 ~ /[0-9].*/ {sum+=$5}END {print sum/1024/1024 " MB"}'

