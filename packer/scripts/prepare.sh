#!/bin/bash

# Set up sudo
echo %ubuntu ALL=NOPASSWD:ALL > /etc/sudoers.d/ubuntu
chmod 0440 /etc/sudoers.d/ubuntu
# Setup sudo to allow no-password sudo for "sudo"
usermod -a -G sudo ubuntu
