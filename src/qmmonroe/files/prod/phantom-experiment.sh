#!/bin/bash

phantomjs —netsniff.js —domain $1 > /opt/monroe/phantom-domain-$1.har
mv /opt/monroe/phantom-domain-$1.har /monroe/results/phantom-domain-$1.har
