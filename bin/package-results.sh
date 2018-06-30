#
# package-results.sh - package the data files resulting from a scenario
#                      execution

if [ -z "$1" ]
then
   echo "USAGE: $0 scenarioname"
   exit 1
fi

date_string=$(date +%Y%m%d-%H%M%S)
file_name="${1}-${date_string}.tar.gz"

file_list="zipkin_db.sql telegraf.line.dmp docker_network.json pidstat.out"

tar czf ${file_name} ${file_list}

