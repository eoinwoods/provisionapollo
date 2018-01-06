#
# stop-services.sh - stop the Apollo environment via Docker Compose 
#
ROOTDIR=${ROOTDIR:-$PWD}

echo "========== Running docker-compose to stop services"
sudo docker-compose -f $ROOTDIR/etc/apollo-env.yml down
