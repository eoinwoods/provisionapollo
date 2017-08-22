#!/bin/bash -x
#
# This script sets up a remote Linux VM so that Ansible can provision it
# This involves copying an SSH keyfile across to the root user's authorised
# keys (which involves typing in a password for "root" to allow this) and
# then using the password-less connection to install Python
#

USAGE="$0 hostname sshkeyfile [user] [idfile]"

if [ $# -lt 2 ]
then
   echo $USAGE
   exit 1
fi
host=$1
keyfile=$2
user=root
idfile=""
if [ $# -gt 2 ]
then
   user=$3
fi
if [ $# -gt 3 ]
then
   idfile=$4
fi

if [ ! -z "$idfile" ]
then
   idfile_param="-i $idfile"
fi

cat $keyfile | ssh $idfile_param $user@$host "cat >> ~/.ssh/authorized_keys"

ssh $idfile_param $user@$host sudo apt-get --assume-yes install python

