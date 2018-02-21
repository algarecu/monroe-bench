#!/bin/bash

# Extract the inferfaces
declare -a interfaces

# Get the interfaces
if [ -f /etc/lsb-release ] ; then
  version="ubuntu"
  ifconfig | grep "Link encap" | awk '{ print $1 '} > /opt/monroe/interfaces.txt
elif [ -f /etc/debian_version ]; then
  version="debian"
  ifconfig -a | sed 's/[ \t].*//;/^\(lo\|\)$/d' > /opt/monroe/interfaces.txt
fi
echo "Version is $version"

IFS=$'\r' GLOBIGNORE='*' command eval 'interfaces=($(cat /opt/monroe/interfaces.txt))'
interfaces=$(sed 's/\:$//' <<< "$interfaces")
interfaces=$(sed 's/\:$//' <<< "$interfaces")
interfaces=( $interfaces )

interfacesarray=(op0 op1 op2 eth0)

# Global timestamp
timestamp=$(date "+%s")
echo "The timetamp of the experiment is" $timestamp
# echo $'The interfaces found are\n'
# echo "${interfaces}"
# echo $'\n'

# Interfaces that exist
for i in "${interfaces[@]}"
do
  for j in "${interfacesarray[@]}"
  do
    if [ "$i" = "$j" ]; then
      # $NAME $DURATION $TARGET $INTERFACE $TIMESTAMP
      if [ $1 = "ping" ]; then
        echo "The name is " $1
        echo "The duration is " $2
        echo "The target is " $3
        echo "The interface is " $i
        /opt/monroe/${1}-experiment.sh $3 $2 $i $timestamp
      elif [ $1 = "traceroute" ]; then
        echo "The name is " $1
        echo "The target is " $2
        echo "The interface is " $i
        /opt/monroe/${1}-experiment.sh $2 $i $timestamp
      elif [ $1 = "dig" ]; then
        if [ $version = "debian" ]; then
          ip=$(ifconfig $i | grep 'inet'| grep -v '127.0.0.1' | awk '{ print $2 }')
        elif [ $version = "ubuntu" ]; then
          ip=$(ifconfig $i | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
        fi
        echo "The name is " $1
        echo "The target is " $2
        echo "The ip is " $ip
        echo "The interface is " $i
        /opt/monroe/${1}-experiment.sh $2 $i $timestamp $ip
      elif [ $1 = "traixroute" ]; then
        echo "The name is " $1
        echo "The target is " $2
        echo "The interface is " $i
        /opt/monroe/${1}-experiment.sh $2 $i $timestamp
      elif [ $1 = "curl" ]; then
        echo "The name is " $1
        echo "The target is " $2
        echo "The interface is " $i
        /opt/monroe/${1}-experiment.sh $2 $i $timestamp
      elif [ $1 = "phantomjs" ]; then
        echo "The name is " $1
        echo "The target is " $2
        echo "The interface is " $i
        /opt/monroe/${1}-experiment.sh $2 $i $timestamp
      fi
    else
      continue
    fi
  done
done
