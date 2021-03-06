#
# run-scenarios.sh - clear the databases,
#                    run some workload scenarios and 
#                    export the data from the MySQL and InfluxDB databases, 
#                    to capture traces and resource utilisation data sets.
#
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOTDIR=${ROOTDIR:-$PWD}
PATH=$PATH:$ROOTDIR/bin
DEMO_SCENARIOS="single-cpu"

if [ $# -eq 0 ]
then
  scenario_list=$DEMO_SCENARIOS
else
  scenario_list=$*
fi

echo "========== Running scenarios: $scenario_list"
for s in $scenario_list
do
   $SCRIPTDIR/clear-databases.sh

   pidstat -C java -d -u -h -I 1 > pidstat.out 2>&1 &
   mpstat -P ON 1 > mpstat.out 2>&1 &

   echo "========== Waiting 20 seconds to collect initial data"
   sleep 20

   echo Running $s
   curl http://localhost:9999/invoke/$s
   echo Sleeping 5 seconds
   sleep 5

   echo "========== Waiting another 15 seconds to collect data"
   sleep 15

   # Stop writing process level statistics
   killall -HUP pidstat
   # Stop writing machine level CPU statistics
   killall -HUP mpstat

   # Collect sar(1m) stats for CPU, I/O and memory from 10 mins ago to now
   # The explicit LC_TIME setting is to set 24 hour times
   let start_time_secs=$(date +%s)-600
   start_time="$(date -d @$start_time_secs +%H:%M:%S)"
   sar_output_file=sar_stats.out
   LC_TIME=C sar -P ALL -s $start_time > $sar_output_file   # CPU
   LC_TIME=C sar -r     -s $start_time >> $sar_output_file  # Memory
   LC_TIME=C sar -b     -s $start_time >> $sar_output_file  # I/O

   $SCRIPTDIR/export-data.sh
   $SCRIPTDIR/package-results.sh $s
done

