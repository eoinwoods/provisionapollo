#!/bin/bash
#
# generate-load.sh - use "openssl speed" to generate significant CPU load on
#                    on all of the machine's cores
#

cpu_count=$(grep -c ^processor /proc/cpuinfo)
while true
do
   openssl speed -multi $cpu_count > /dev/null 2>&1
done
