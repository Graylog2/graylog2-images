#!/bin/bash

set -x

# in case there are changes for grub
update-grub

# Remove guest additions
rm -f /home/ubuntu/VBoxGuestAdditions.iso

apt-get autoremove
apt-get autoclean
apt-get clean

rm -rf /tmp/* /var/tmp/*
rm -f /var/log/wtmp /var/log/btmp
history -c

# release unused disk space
dd if=/dev/zero of=/EMPTY bs=1M
rm /EMPTY
