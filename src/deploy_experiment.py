#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (C) 2017-2018
# Álvaro García-Recuero, algarecu@gmail.com
#
# This file is part of the Monroe-Bench framework
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses>.

"""
Monroe-Bench for CaMCoW

Created on '21/07/17'
__author__='algarecu'
__email__='algarecu@gmail.com'
"""

import sys
import os
import getopt
import traceback

from subprocess import call
from cli.cli import *

def main(argv):
    # Provide name of experiment
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print ('deploy_experiment.py -i <name_of_experiment> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
      if opt == '-h':
          print ('deploy_experiment.py -i <name_of_experiment> -o <outputfile>')
          sys.exit()
      elif opt in ("-i", "--ifile"):
          name_of_experiment = arg
      elif opt in ("-o", "--ofile"):
          outputfile = arg
    print ('Input file is ' + name_of_experiment)
    print ('Output file is ' + outputfile)
    return name_of_experiment


def deploy():
    '''
    Deploy Docker container: use cli script
    '''
    myoption = None
    options = ['setup', 'create', 'whoami', 'quota', 'experiments', 'delete', 'results']
    if myoption not in options:
        try:
            print ('Please choose deployment choice:')
            myoption = input('Enter option [setup, create, whoami, quota, experiments, delete, results]: ')
        except KeyboardInterrupt:
            print >> sys.stdout, '\n Goodbye: your pressed quit [q]'
            try:
                sys.exit(0)
            except SystemExit:
                os._exit(0)
        except Exception:
            traceback.print_exc(file=sys.stdout)

    myswitch = {
        "create": 0,
        "whoami": 1,
        "quota": 2,
        "experiments": 3,
        "setup": 4,
        "delete": 5,
        "results": 6,
        "exit": 7
    }
    myval = myswitch.get(myoption, None)
    print ('Choosen option is {0}'.format(myval) )

    if myval == None or myval not in range(0, 6, 1):
        print ('Please choose a valid deployment option')

    if myval in range(0,7,1):
        if myval == 0:
            deploy_command = 'python3.6 ./src/cli/cli.py create --name helloworld --testing --countries Spain --start 2017-12-20T19:30:00'
            call(deploy_command.split(), shell=False)
        elif myval == 1:
            deploy_command = 'python3.6 ./src/cli/cli.py whoami'
            call(deploy_command.split(), shell=False)
        elif myval == 2:
            deploy_command = 'python3.6 ./src/cli/cli.py quota'
            call(deploy_command.split(), shell=False)
        elif myval == 3:
            deploy_command = 'python3.6 ./src/cli/cli.py experiments'
            call(deploy_command.split(), shell=False)
        elif myval == 4:
            deploy_command = 'python3.6 ./src/cli/cli.py {0} --cert ./auth/emulab.p12'.format(myoption)
            call(deploy_command.split(), shell=False)
        elif myval == 5:
            deploy_command = 'python3.6 ./src/cli/cli.py delete'
            call(deploy_command.split(), shell=False)
        elif myval == 6:
            deploy_command = 'python3.6 ./src/cli/cli.py results'
            call(deploy_command.split(), shell=False)

def auth():
    '''
    Monroe certificate to pem format.
    You must have the emulab.p12 downloaded in auth folder.
    '''

    call("mkdir -p ./auth", shell=True) # auth folder
    mnr_dir = os.path.join('./','auth')
    mnr_key = str(mnr_dir) + 'mnrKey.pem'
    mnr_crt = str(mnr_dir) + 'mnrCrt.pem'

    # Password to be entered manually

    call('openssl pkcs12 -in ./credentials/emulab.p12 -out ./auth/mnrCrt.pem -clcerts -nokeys', shell=True)
    call('openssl pkcs12 -in ./credentials/emulab.p12 -out ./auth/mnrKey.pem -nocerts -nodes', shell=True)


if __name__ == "__main__":
    name_exp = main(sys.argv[1:])

    # Create directory structure for experiment
    base_dir = 'experiments'
    filename = name_exp
    exp_dir = os.path.join(base_dir, filename)

    files_dir = os.path.join(exp_dir, 'files')
    call("mkdir -p " + files_dir, shell=True) # the .py scripts of the experiment
    call("touch " + str(exp_dir) + "/build.sh", shell=True) # File that acts as template,
    call("touch " + str(exp_dir) + "/push.sh", shell=True) # File to specify name of Docker repository
    call("touch " + str(exp_dir) + "/readme.md", shell=True) # description of the experiment
    call("touch " + str(exp_dir) + "/" + str(filename) + ".docker", shell=True) # name of the docker container, normally name of the experiment.docker

    # Deploy
    auth()
    deploy()
