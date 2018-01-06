#
# run-scenarios.sh - start the Apollo environment via Docker Compose, then clear the databases,
#                    run some workload scenarios and export the data from the MySQL and InfluxDB
#                    databases, to capture traces and resource utilisation data sets.
#
ROOTDIR=${ROOTDIR:-$PWD}


echo "Refreshing Energy Services containers"
sudo docker pull eoinwoods/gateway-service
sudo docker pull eoinwoods/cpuhog-service

echo "========== Running docker-compose to start services"
cp $ROOTDIR/etc/apollo_telegraf.conf /tmp
sudo docker-compose -f $ROOTDIR/etc/apollo-env.yml up -d

echo "========== Waiting 30 seconds"
sleep 30

echo "========== Deleting all rows from Zipkin MySQL database"
sudo docker run -i --net=container:mysql mariadb mysql -hmysql -P3306 -uzipkin -pzipkin -Dzipkin <<EOF
use zipkin ;
delete from zipkin_annotations ;
delete from zipkin_dependencies ;
delete from zipkin_spans ;
commit ;
EOF


echo "========== Dropping Influxdb measurements from telegraf database"
sudo docker run -i --net=container:influxdb influxdb influx -database telegraf <<EOF
drop measurement docker ;
drop measurement docker_container_blkio ;
drop measurement docker_container_cpu ;
drop measurement docker_container_mem ;
drop measurement docker_container_net ;
EOF

echo "========== Removing old Energy Services containers"
sudo docker rm gateway 
sudo docker rm cpuhog

echo "========== Starting Energy Services"
sudo docker run -d --name gateway -p 9999:9999 eoinwoods/gateway-service
sudo docker run -d --name cpuhog --net=container:gateway eoinwoods/cpuhog-service

echo "========== Waiting 30 seconds"
sleep 30

echo "========== Running scenarios"
curl http://localhost:9999/invoke/single-cpu
sleep 10
curl http://localhost:9999/invoke/three-cpu
sleep 10
curl http://localhost:9999/invoke/single-cpu

echo "========== Waiting 30 seconds"
sleep 30

echo "========== Exporting Zipkin data"
sudo docker run --net=container:mysql mariadb mysqldump -hmysql -P3306 -uzipkin -pzipkin zipkin > zipkin_db.sql

echo "========== Exporting InfluxDB data"
sudo docker exec influxdb influx_inspect export -database telegraf -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal -out /tmp/telegraf.line.dmp
sudo docker cp influxdb:/tmp/telegraf.line.dmp .

echo "Scenario run complete - services can be shutdown via Docker and Docker Compose now"





