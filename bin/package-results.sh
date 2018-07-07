#
# package-results.sh - package the data files resulting from a scenario
#                      execution

if [ -z "$1" ]
then
   echo "USAGE: $0 scenarioname"
   exit 1
fi
scenario_name=$1

date_string=$(date +%Y%m%d-%H%M%S)
file_name="${scenario_name}-${date_string}.tar"

file_list="zipkin_db.sql telegraf.line.dmp \
           docker_network.json pidstat.out sar_stats.out"

echo "========== Packaged results for $scenario_name into $file_name"
tar cf ${file_name} ${file_list}

