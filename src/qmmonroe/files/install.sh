#!/bin/bash

sed --in-place 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
apt-get update && apt-get install -qq -y --no-install-recommends \
  iputils-ping \
  chrpath \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# apt-transport-https \
# gcc \
# g++ \
# software-properties-common \
# git \
# traceroute \
# dnsutils \
# curl \
# wget \
# build-essential

# echo "Installing dependencies for tracebox, traceixroute, phantom..." && sleep 5
# apt-get update && apt-get install --no-install-recommends -y \
   # gcc \
   # autotools-dev \
   # automake \
   # libtool \
   # liblua5.1-0-dev \
   # libpcap-dev \
   # libcurl4-gnutls-dev \
   # lua-ldoc \
   # libnetfilter-queue-dev \
   # libjson-c-dev \
   # g++ \
   # python3-setuptools \
   # python3-dev \
   # python3-requests \
   # python3-urllib3 \
   # python3-pip \
   # libxft-dev \
   # libfreetype6 \
   # libfontconfig \
   # libssl-dev \
   # libffi-dev \
   # && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# GNU parallel
# (wget pi.dk/3 -qO - ||  curl pi.dk/3/) | bash

# Install tracebox from orig repo
# mkdir -p /opt/monroe/tools \
#   && cd /opt/monroe/tools \
#   && git clone https://github.com/tracebox/tracebox.git \
#   && cd tracebox \
#   && ./bootstrap.sh \
#   && ./bootstrap.sh \
#   && ./configure \
#   && make \
#   && make install

# Install traIXroute from my forked repo
# mkdir -p /opt/monroe/tools \
#   && cd /opt/monroe/tools \
#   && git clone https://github.com/algarecu/traixroute.git \
#   && cd traixroute \
#   && git checkout v2.3 \
#   && alias python=/usr/bin/python3.5 \
#   && sh ./setup/install.sh \
#   && python setup.py --help-commands \
#   && ./bin/traixroute \
#   && echo "Installed traIXroute version" \
#   && ./bin/traixroute --version

# Install phantomjs as seen in https://gist.github.com/julionc/7476620
# PHANTOM_VERSION="phantomjs-1.9.8"
# ARCH=$(uname -m)
#
# if ! [ $ARCH = "x86_64" ]; then
# 	$ARCH="i686"
# fi
#
# PHANTOM_JS="$PHANTOM_VERSION-linux-$ARCH"
#
# mkdir -p /opt/monroe/tools \
#   && cd /opt/monroe/tools \
#   && wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 \
#   && tar xvjf $PHANTOM_JS.tar.bz2 \
#   && mv $PHANTOM_JS /usr/local/share \
#   && ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin \
#   && echo "Installed phantomjs version" && phantomjs --version
