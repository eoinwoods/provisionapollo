Setup for Apollo Environment
============================

To use these scripts then ...

1. Install and test Ansible locally
1. Create a Linux VM to use
1. Use the initial-setup.sh script to copy an SSH key for the remote "root" user to the VM and install Python
1. Create an "inventory" file containing a host list called "defaulthosts" containing the target vm name(s)
1. Add a [defaulthosts:vars] section to "inventory" to define:
   * username: the non-root user to provision
   * password_hash: an SHA512 hash for a password for the user
1. Run Ansible:
   * ansible-playbook provision.yml -i inventoryfile
1. Use bin/run-scenarios.sh to run a set of Apollo scenarios and unload Zipkin and InfluxDB data

The initial-setup.sh step should create a non-root user in the "sudo" (and "users") group, allow the "sudo" group to "sudo" without a password on the new VM, install the Python packages "python-pip" and "python-apt", install Docker (and docker-compose) and install "fail2ban" with its default configuration.

The key scripts for running the scenarios are:

* bin/start-services.sh - pull the latest services containers and start the environment via "docker-compose up"
* bin/stop-services.sh - shut down the environment via "docker-compose down"
* bin/run-scenarios.sh - clear the databases, run some scenarios, export the databases

There are then some subscripts and useful utility scripts in the "bin" directory too.


Eoin Woods
