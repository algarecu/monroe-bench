#!/bin/sh

echo "Removing dependencies for tracebox, traceixroute, phantom..." && sleep 5
apt-get remove -y \
    gcc \
    autotools-dev \
    automake \
    libtool \
    liblua5.1-0-dev \
    libpcap-dev \
    libcurl4-gnutls-dev \
    lua-ldoc \
    libnetfilter-queue-dev \
    libjson-c-dev \
    g++ \
    python3 \
    python3-setuptools \
    python3-dev \
    python3-requests \
    python3-urllib3 \
    python3-pip \
    libssl-dev \
    libffi-dev \
    libfreetype6-dev \
    libfontconfig1
