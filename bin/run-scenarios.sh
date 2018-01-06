#
# run-scenarios.sh - clear the databases,
#                    run some workload scenarios and 
#                    export the data from the MySQL and InfluxDB databases, to capture traces 
#                    and resource utilisation data sets.
#
ROOTDIR=${ROOTDIR:-$PWD}
PATH=$PATH:$ROOTDIR/bin

clear-databases.sh

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

export-data.sh




