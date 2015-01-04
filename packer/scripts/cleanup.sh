#!/bin/bash

set -x

# in case there are changes for grub
update-grub

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm -f /var/lib/dhcp/*
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

apt-get autoremove
apt-get autoclean
apt-get clean

rm -rf /tmp/* /var/tmp/*
rm -f /var/log/wtmp /var/log/btmp
history -c

# release unused disk space
dd if=/dev/zero of=/EMPTY bs=1M
rm /EMPTY
