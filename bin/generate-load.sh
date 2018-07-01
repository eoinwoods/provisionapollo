#!/bin/bash
#
# generate-load.sh - use "openssl speed" to generate CPU load on the machine
#                    runs on a single cpu
#
while true
do
   openssl speed > /dev/null 2>&1
done
