#!/bin/bash
# repeat-scenario.sh - script to run a scenario a number of times, collecting
#                      the results each time
#
USAGE="$0 scenarioname repeatcount"

if [ "$#" -ne 2 ]
then
   echo $USAGE
   exit 1
fi

if ! [[ "$2" =~ ^[0-9]+$ ]] 
then
   echo $USAGE
   exit 2
fi

# The default place for the scripts we call is our script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PATH=$PATH:$DIR

SCENARIO=$1
COUNT=$2

echo "Running scenario $SCENARIO $COUNT times"
for ((i=1; i <= $COUNT; i++))
do
  echo "Scenario $SCENARIO invocation $i at $(date +%Y%M%d-%H%M%S)"
  run-scenarios.sh $SCENARIO
  package-results.sh $SCENARIO
done

