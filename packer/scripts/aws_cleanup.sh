#!/bin/bash

set -x

# in case there are changes for grub
update-grub

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm -f /var/lib/dhcp/*

apt-get autoremove
apt-get autoclean
apt-get clean

rm -rf /tmp/* /var/tmp/*
rm -f /var/log/wtmp /var/log/btmp
rm -f /root/.ssh/authorized_keys
rm -f /home/ubuntu/.ssh/authorized_keys
rm -rf /var/lib/cloud
history -c
