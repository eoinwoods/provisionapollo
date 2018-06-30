#
# run-scenarios.sh - clear the databases,
#                    run some workload scenarios and 
#                    export the data from the MySQL and InfluxDB databases, 
#                    to capture traces and resource utilisation data sets.
#
ROOTDIR=${ROOTDIR:-$PWD}
PATH=$PATH:$ROOTDIR/bin

if [ $# -eq 0 ]
then
  scenario_list="single-cpu three-cpu single-cpu data-500mb-4times cpu-data-mix"
else
  scenario_list=$*
fi

clear-databases.sh

pidstat -C java -d -u -h -I 1 > pidstat.out 2>&1 &

echo "========== Waiting 30 seconds to collect initial data"
sleep 30

echo "========== Running scenarios: $scenario_list"
for s in $scenario_list
do
   echo Running $s
   curl http://localhost:9999/invoke/$s
   echo Sleeping 5 seconds
   sleep 5
done

echo "========== Waiting another 25 seconds to collect data"
sleep 20

killall -HUP pidstat

export-data.sh




