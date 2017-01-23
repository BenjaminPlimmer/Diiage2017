#!/bin/bash

ipcs | awk '{ if ($5 ~ /^[0-9]*$/) sum+=$5;}END {print sum/1048576 " Mo"}'

exit 0
