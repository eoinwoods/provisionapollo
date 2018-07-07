#!/bin/bash
#
# generate-load.sh - use "openssl speed" to generate significant CPU load on
#                    on all of the machine's cores
#

cpu_count=$(grep -c ^processor /proc/cpuinfo)
parallel_degree=$cpu_count
if [ ! -z "$1" ]
then
   if [ $1 -ge 1 -a $1 -le $cpu_count ]
   then
      parallel_degree=$1
   else
      echo "Invalid parallel degree of $1 -- exiting"
      exit 1
   fi
fi
while true
do
   openssl speed -multi $parallel_degree > /dev/null 2>&1
done
