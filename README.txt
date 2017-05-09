To use these scripts then ...

(0) Install and test Ansible locally
(1) Create a Linux VM to use
(2) Use the initial-setup.sh script to copy an SSH key for the remote "root"
    user to the VM and install Python
(3) Create an "inventory" file containing a host list called "defaulthosts"
    containing the target vm name(s)
(4) Add a [defaulthosts:vars] section to "inventory" to define:
    - username: the non-root user to provision
    - password_hash: an SHA512 hash for a password for the user
    - accountkey: a SETI@Home account key (if SETI@Home is to be installed)
(5) Run Ansible:
       ansible-playbook provision.yml -i inventoryfile
       ansible-playbook install-setiathome.yml -i inventoryfile

This should create a non-root user in the "sudo" (and "users") group, 
allow the "sudo" group to "sudo" without a password on the new VM, install 
the Python packages "python-pip" and "python-apt" and install "fail2ban" 
with its default configuration.

If "install-setiathome" is also used, then the Boinc client is installed with
a configuration file connecting it to SETI@Home with the specified user
account key.

Eoin Woods
9 May 2017



