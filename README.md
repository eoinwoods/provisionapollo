Provision a New VM
==================

To use these scripts then ...

1. Install and test Ansible locally
1. Create a Linux VM to use
1. Use the initial-setup.sh script to copy an SSH key for the remote "root" user to the VM and install Python
1. Create an "inventory" file containing a host list called "defaulthosts" containing the target vm name(s)
1. Add a [defaulthosts:vars] section to "inventory" to define:
   * username: the non-root user to provision
   * password_hash: an SHA512 hash for a password for the user
1. Optionally add a "install_docker" variable to the variables list, to install Docker
1. Run Ansible:
   * ansible-playbook provision.yml -i inventoryfile

This should create a non-root user in the "sudo" (and "users") group, allow the "sudo" group to "sudo" without a password on the new VM, install the Python packages "python-pip" and "python-apt" and install "fail2ban" with its default configuration.

If "install_docker" was defined as a variable then you get Docker and Docker Compose installed too.  The Docker Compose installation needs work as it is very fragile (using curl to retrieve it!).  The Docker
installation should probably be factored out into its own playbook in any case.

If "install-setiathome" is also used, then the Boinc client is installed with a configuration file connecting it to SETI@Home with the specified user account key.  Similarly if the "install-geth" playbook is used then the latest Ethereum "Geth" client will be installed (along with some pre-requisites such as Python virtualenv).

Eoin Woods
