#!/bin/bash

# $TARGET=1 $DURATION=2 $INTERFACE=3 $TIMESTAMP=4
echo "The command is: ping -I $3 -w $2 $1"

# Add header
echo "address,sequence,time" > /opt/monroe/ping-interface-$3-dest-$1-$4-out.csv
ping -I $3 -w $2 $1 | while read line; do
  # Do not skip header
  [[ "$line" =~ ^PING ]] && header=$line && echo "$header" > /opt/monroe/ping-interface-$3-dest-$1-$4-out-header.csv && continue

  # Skip non-positive responses
  [[ ! "$line" =~ "bytes from" ]] && continue

  # Extract address field
  addr=${line##*bytes from }
  addr=${addr%%:*}

  # Extract seq
  seq=${line##*icmp_seq=}
  seq=${seq%% *}

  # Extract time
  time=${line##*time=}
  time=${time%% *}

  echo "$addr,$seq,$time" >> /opt/monroe/ping-interface-$3-dest-$1-$4-out.csv
done
echo "Moving measurements to /monroe/results"
mv /opt/monroe/ping-interface-$3-dest-$1-$4-out.csv /monroe/results/ping-interface-$3-dest-$1-$4-out.csv
