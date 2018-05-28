#
# clear-databases.sh - clear the InfluxDB and Zipkin MySQL databases of relevant data
#
ROOTDIR=${ROOTDIR:-$PWD}

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
drop measurement cpu ;
drop measurement disk ;
drop measurement diskio ; 
drop measurement kernel ;
drop measurement mem ;
drop measurement processes ;
drop measurement swap ;
drop measurement system ;
drop measurement docker ;
drop measurement docker_container_blkio ;
drop measurement docker_container_cpu ;
drop measurement docker_container_mem ;
drop measurement docker_container_net ;
EOF
