#!/bin/bash

numberofargs=("$#")
if [ $numberofargs -eq 2 ]
  tracebox -j $2 >> /opt/monroe/results/$1-out.csv
fi
mv /opt/monroe/$1-out.csv /monroe/results/$1-out.csv
