#!/bin/bash

set -x

echo -e "cloud-init cloud-init/datasources multiselect NoCloud, ConfigDrive, OpenStack, CloudStack, None\ncloud-init cloud-init/local-cloud-config string apt_preserve_sources_list: true" > /tmp/cloud-init.seed
debconf-set-selections /tmp/cloud-init.seed

apt-get install -y linux-virtual
apt-get install -y cloud-init
apt-get install -y cloud-guest-utils
apt-get install -y cloud-initramfs-growroot
apt-get install -y cloud-initramfs-rescuevol

# configure cloud-init
sed -i '/^[[:blank:]-]\+http:\/\/%(ec2_region)s.*/ d' /etc/cloud/cloud.cfg

# change network configuration to work with cloud-init
sed -i 's/allow-hotplug eth0/auto eth0/' /etc/network/interfaces
