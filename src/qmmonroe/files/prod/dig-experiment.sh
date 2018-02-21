#!/bin/bash

# Check the list of resolvers
cat /etc/resolv.conf

# TARGET=$1, INTERFACE=$2, TIMESTAMP=$3, IP=$4
dig -b $4 -4 +trace +short $1 > /opt/monroe/dig-interface-$2-ip-$4-dest-$1-$3-v4-out.log
mv /opt/monroe/dig-interface-$2-ip-$4-dest-$1-$3-v4-out.csv /monroe/results/dig-interface-$2-ip-$4-dest-$1-$3-v4-out.log

dig -b $4 -6 +trace +short $1 > /opt/monroe/dig-interface-$2-ip-$4-dest-$1-$3-v6-out.log
mv /opt/monroe/dig-interface-$2-ip-$4-dest-$1-$3-v6-out.csv /monroe/results/dig-interface-$2-ip-$4-dest-$1-$3-v6-out.log
