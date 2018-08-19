#
# package-results.sh - package the data files resulting from a scenario
#                      execution including adding identification data to
#                      the InfluxDb and MySQL data sets

if [ -z "$1" ]
then
   echo "USAGE: $0 scenarioname"
   exit 1
fi
scenario_name=$1

date_string=$(date +%Y%m%d-%H%M%S)
dataset_name="${scenario_name}-${date_string}"
file_name="${dataset_name}.tar"

zipkin_file=zipkin_db.sql
telegraf_file=telegraf.line.dmp
file_list="$zipkin_file $telegraf_file \
           docker_network.json pidstat.out mpstat.out sar_stats.out"

echo "========== Adding dataset name metadata to data set"
influxrow="apollo_check,data_set=$dataset_name,application=apollo value=1 1527811200000000000"
zipkinrow="insert into zipkin.zipkin_spans values(0, 0, 1, '$dataset_name', 0, null, 1527811200000, 0);"
echo ${influxrow} >> ${telegraf_file}
echo ${zipkinrow} >> ${zipkin_file}

echo "========== Packaged results for $scenario_name into $file_name"
tar cf ${file_name} ${file_list}

