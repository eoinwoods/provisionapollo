#! /usr/bin/python
# This script hashes a password, read from the terminal, using the SHA512
# algorithm, which allows it to be used as an Ansible compatible password
# hash (in the "inventory" file or other variable for example)
#
from passlib.hash import sha512_crypt; 
import getpass; 
p = getpass.getpass()
print "Password: " + p
print "Hash:     " + sha512_crypt.using(rounds=5000).hash(p)
