#
# run-scenarios.sh - clear the databases,
#                    run some workload scenarios and 
#                    export the data from the MySQL and InfluxDB databases, 
#                    to capture traces and resource utilisation data sets.
#
ROOTDIR=${ROOTDIR:-$PWD}
PATH=$PATH:$ROOTDIR/bin
DEMO_SCENARIOS="single-cpu three-cpu single-cpu data-500mb-4times cpu-data-mix"

if [ $# -eq 0 ]
then
  scenario_list=$DEMO_SCENARIOS
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

# Stop writing process level statistics
killall -HUP pidstat

# Collect sar(1m) stats for CPU, I/O and memory from 10 mins ago to now
# The explicit LC_TIME setting is to set 24 hour times
let start_time_secs=$(date +%s)-600
start_time="$(date -d @$start_time_secs +%H:%M:%S)"
sar_output_file=sar_stats.out
LC_TIME=C sar -P ALL -s $start_time > $sar_output_file   # CPU
LC_TIME=C sar -r     -s $start_time >> $sar_output_file  # Memory
LC_TIME=C sar -b     -s $start_time >> $sar_output_file  # I/O
 
export-data.sh




