#!/bin/bash

ls -la /usr/bin/python*
rm -f /opt/monroe/commands.txt
alias python3=/usr/bin/python3.5
python3 /opt/monroe/workload.py > /opt/monroe/commands.txt

# Curl fetch node info metadata from localhost: testing
# curl -s http://localhost:88/modems | jq > /monroe/results/node-metadata.json

while read p
do
  echo "Running: /opt/monroe/entrypoint.sh $p"
  /opt/monroe/entrypoint.sh $p
done < /opt/monroe/commands.txt
