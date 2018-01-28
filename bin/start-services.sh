#
# start-services.sh - start the Apollo environment via Docker Compose having pulled the latest
#                     services containers
#
ROOTDIR=${ROOTDIR:-$PWD}


echo "Refreshing Energy Services containers"
sudo docker pull eoinwoods/gateway-service
sudo docker pull eoinwoods/cpuhog-service
sudo docker pull eoinwoods/datahog-service

echo "========== Running docker-compose to start services"
cp $ROOTDIR/etc/apollo_telegraf.conf /tmp
sudo docker-compose -f $ROOTDIR/etc/apollo-env.yml up -d
