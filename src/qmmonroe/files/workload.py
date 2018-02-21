#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
    Parser.py: produce the desired workload from a JSON file
    Author: Alvaro Garcia Recuero
    Date created: 11/30/2017
    Date last modified: 4/25/2013
    Python Version: Python 3
'''

# Usage: python3 workload.py > commands.txt
# Output: $NAME $TARGET $DURATION

import json
import os.path
import urllib.request
from pprint import pprint

if os.path.exists("/monroe/config"):
    jsondata = json.load(open("/monroe/config"))
else:
    urlData = "http://www.eecs.qmul.ac.uk/~alvarogr/monroe-config-alexa10top.json"
    webURL = urllib.request.urlopen(urlData)
    data = webURL.read()
    encoding = webURL.info().get_content_charset('utf-8')
    jsondata = json.loads(data.decode(encoding))

command = []
monroe_duration = 30

# Work in progress: get the interfaces to use in reservation from monroe-cli, -ifcount takes an int
for res in jsondata["reservation"]:
    # interfaces = int (res["interfaces"])
    if int (res["interfaces"]) == 1 or int (res["interfaces"]) == 2:
        interfaces = 2

for exp in jsondata["experiment"]:
    if exp["duration"]:
        monroe_duration = exp["duration"] * exp["probes"] * len(exp["target"]) * interfaces + (exp["probes"] - 1 + exp["interval"])
    else:
        monroe_duration += monroe_duration
duration = "Experiment duration should be " + str(monroe_duration)
print(duration)

for exp in jsondata["experiment"]:
    if exp["duration"]:
        if exp["name"] == "ping":
            for target in exp["target"]:
                for i in range(int(exp["probes"])):
                    command = exp["name"] + " " + str(exp["duration"]) + " " + str(target)
                    print(command)
                    # print ("sleep" + " " + str(exp["interval"]))
        elif exp["name"] == "traceroute":
            for target in exp["target"]:
                for i in range(int(exp["probes"])):
                    command = exp["name"] + " " + str(target)
                    command = exp["name"] + " " + str(target)
                    print(command)
        elif exp["name"] == "traixroute":
            for target in exp["target"]:
                for i in range(int(exp["probes"])):
                    command = exp["name"] + " " + str(target)
                    command = exp["name"] + " " + str(target)
                    print(command)
        elif exp["name"] == "tracebox":
            for target in exp["target"]:
                for i in range(int(exp["probes"])):
                    command = exp["name"] + " " + str(target)
                    command = exp["name"] + " " + str(target)
                    print(command)
        elif exp["name"] == "curl":
            for target in exp["target"]:
                for i in range(int(exp["probes"])):
                    command = exp["name"] + " " + str(target)
                    command = exp["name"] + " " + str(target)
                    print(command)
        elif exp["name"] == "dig":
            for target in exp["target"]:
                for i in range(int(exp["probes"])):
                    command = exp["name"] + " " + str(target)
                    command = exp["name"] + " " + str(target)
                    print(command)
        elif exp["name"] == "phantom":
            for target in exp["target"]:
                for i in range(int(exp["probes"])):
                    command = exp["name"] + " " + str(target)
                    command = exp["name"] + " " + str(target)
                    print(command)
        else:
            break
