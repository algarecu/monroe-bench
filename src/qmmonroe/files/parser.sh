#!/bin/bash

ls -la /usr/bin/python*
rm -f /opt/monroe/commands.txt
alias python3=/usr/bin/python3.5
python3 /opt/monroe/workload.py > /opt/monroe/commands.txt

while read p
do
  echo "Running: /opt/monroe/entrypoint.sh $p"
  /opt/monroe/entrypoint.sh $p
done < /opt/monroe/commands.txt
