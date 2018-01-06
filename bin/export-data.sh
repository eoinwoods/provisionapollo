#
# export-data.sh - export the Zipkin MySQL database and the "telegraf" database from InfluxDB
#
ROOTDIR=${ROOTDIR:-$PWD}

echo "========== Exporting Zipkin data"
sudo docker run --net=container:mysql mariadb mysqldump -hmysql -P3306 -uzipkin -pzipkin zipkin > zipkin_db.sql

echo "========== Exporting InfluxDB data"
sudo docker exec influxdb influx_inspect export -database telegraf -datadir /var/lib/influxdb/data -waldir /var/lib/influxdb/wal -out /tmp/telegraf.line.dmp
sudo docker cp influxdb:/tmp/telegraf.line.dmp .





