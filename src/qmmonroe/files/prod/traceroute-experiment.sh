#!/bin/bash

# TARGET=$1, INTERFACE=$2, TIMESTAMP=$3
echo "Starting traceroute..."
traceroute -n -i $2 $1 | while read line
  do
    echo "$line" >> /opt/monroe/traceroute-interface-$2-dest-$1-$3-out.log
  done
echo "Moving measurements to /monroe/results"
mv /opt/monroe/traceroute-interface-$2-dest-$1-$3-out.log /monroe/results/traceroute-interface-$2-dest-$1-$3-out.log

sleep 5
# Parse results
# perl -w /opt/monroe/traceroute_parse.pl /opt/monroe/traceroute-interface-$2-dest-$1-$3-out.csv
# mv /opt/monroe/traceroute-interface-$2-dest-$1-$3-out.csv /monroe/results/traceroute-interface-$2-dest-$1-$3-out.csv
