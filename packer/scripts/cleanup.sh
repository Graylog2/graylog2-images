#!/bin/bash

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

apt-get clean
rm -rf /tmp/* /var/tmp/*

dd if=/dev/zero of=/EMPTY bs=1M
rm /EMPTY
