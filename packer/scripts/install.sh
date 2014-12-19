#!/bin/bash

apt-get update
apt-get install -y curl
wget -O /tmp/graylog2.deb https://packages.graylog2.org/releases/graylog2-omnibus/ubuntu/graylog2_latest.deb
dpkg -i /tmp/graylog2.deb
rm /tmp/graylog2.deb
