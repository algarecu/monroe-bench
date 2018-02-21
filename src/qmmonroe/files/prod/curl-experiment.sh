#!/bin/bash

# $1=TARGET $2=INTERFACE $3=TIMESTAMP
curl -i -L $3 --interface $2 -4  > /opt/monroe/curl-$1-interface-$2-$3-v4-out.log
curl -i -L $3 --interface $2 -6  > /opt/monroe/curl-$1-interface-$2-$3-v6-out.log
curl -i -L http://proxydb.net/anon --interface $2 -4 > /opt/monroe/curl-proxydb-headers-$1-interface-$2-$3-v4-out.log
curl -i -L http://proxydb.net/anon --interface $2 -6 > /opt/monroe/curl-proxydb-headers-$1-interface-$2-$3-v6-out.log

mv /opt/monroe/curl-$1-$2-$3-v4-out.csv /monroe/results/curl-$1-interface-$2-$3-v4-out.log
mv /opt/monroe/curl-$1-$2-$3-v6-out.csv /monroe/results/curl-$1-interface-$2-$3-v6-out.log
mv /opt/monroe/curl-proxydb-headers-$1-interface-$2-$3-v4-out.csv /monroe/results/curl-proxydb-headers-$1-interface-$2-$3-v4-out.log
mv /opt/monroe/curl-proxydb-headers-$1-interface-$2-$3-v6-out.csv /monroe/results/curl-proxydb-headers-$1-interface-$2-$3-v6-out.log
