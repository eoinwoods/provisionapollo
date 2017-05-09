#!/bin/bash -x
#
# This script sets up a remote Linux VM so that Ansible can provision it
# This involves copying an SSH keyfile across to the root user's authorised
# keys (which involves typing in a password for "root" to allow this) and
# then using the password-less connection to install Python
#

USAGE="$0 hostname sshkeyfile"

if [ $# -lt 2 ]
then
   echo $USAGE
   exit 1
fi
host=$1
keyfile=$2

cat $keyfile | ssh root@$host "cat >> ~/.ssh/authorized_keys"

ssh root@$host apt-get install python

