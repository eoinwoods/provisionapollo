#
# apollo-env-setup.sh - setup Apollo runtime environment on empty Ubuntu (AWS) VM using
#                       manual "docker run" commands rather than "docker-compose"
#

sudo apt-get update -y
sudo apt-get upgrade -y

# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce-1
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce
sudo docker run hello-world

sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version

# https://zipkin.io/pages/quickstart
# Remember the -d which means "detach" to run in background
sudo docker run -d --name zipkinserver -p 9411:9411 openzipkin/zipkin

# https://hub.docker.com/_/telegraf/
sudo docker run -d --name influxdb -p 8083:8083 -p 8086:8086 influxdb
# Need to copy apollo_telegraf.conf into place as part of setup
sudo docker run -d --net=container:influxdb --name telegraf -v /var/run/docker.sock:/var/run/docker.sock -v ~/etc/apollo_telegraf.conf:/etc/telegraf/telegraf.conf:ro telegraf

# -it == interactive and allocate a tty
sudo docker run -it --net=container:influxdb influxdb influx
