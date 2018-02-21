#!/bin/bash

# TARGET=$1, INTERFACE=$2, TIMESTAMP=$3
numberofargs=("$#")
if [ $numberofargs -eq 3 ]; then
  # echo "Running /opt/monroe/tools/traixroute/bin/traixroute -asn -rule -stats -ojson -otxt -db probe -t -dest $1 > /opt/monroe/$3-traixroute-interface-$2-ip-$4-dest-$1.csv"
  # /opt/monroe/tools/traixroute/bin/traixroute -asn -rule -stats -ojson -otxt -db probe -t -dest $1 > /opt/monroe/$3-traixroute-interface-$2-ip-$4-dest-$1.csv
  echo "Running /opt/monroe/tools/traixroute/bin/traixroute -u -m -asn -rule -db -dns probe -t -dest $1"
  cd /opt/monroe/tools/traixroute
  ./bin/traixroute -u -m -asn -rule -db -dns probe -t -dest $1 > /opt/monroe/$3-traixroute-interface-$2-ip-$4-dest-$1.csv
else
  echo "Missing arguments: Got $numberofargs arguments when we should have 3"
fi
mv /opt/monroe/$3-traixroute-interface-$2-ip-$4-dest-$1.csv /monroe/results/$3-traixroute-interface-$2-ip-$4-dest-$1.csv
