#
# start-services.sh - start the Apollo environment via Docker Compose having 
#                     pulled the latest services containers
#
ROOTDIR=${ROOTDIR:-$PWD}


echo "Refreshing Energy Services containers"
sudo docker pull eoinwoods/gateway-service
sudo docker pull eoinwoods/cpuhog-service
#sudo docker pull eoinwoods/datahog-service
sudo docker pull eoinwoods/fiohog-service

echo "========== Running docker-compose to start services"
# This env var is used for the Docker network name created by Compose
export COMPOSE_PROJECT_NAME=apollo
cp $ROOTDIR/etc/apollo_telegraf.conf /tmp
sudo docker-compose -f $ROOTDIR/etc/apollo-env.yml up -d
