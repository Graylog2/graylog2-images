#!/bin/bash

set +x
set -e

if [ -z "$PACKAGE_VERSION" ] ; then
  echo "No package version set, exiting."
  exit 1
fi
echo "Building image for Graylog $PACKAGE_VERSION"

export DEBIAN_FRONTEND=noninteractive

# Update repositories
apt-get update
apt-get dist-upgrade -y -o Dpkg::Options::="--force-confdef"
# Install tools needed for installation
apt-get install -y apt-transport-https curl wget rsync vim man sudo avahi-autoipd pwgen uuid-runtime gnupg net-tools open-vm-tools
apt-get install -y tzdata ntp ntpdate

# Prepare repositories
apt-key adv --fetch-keys https://artifacts.elastic.co/GPG-KEY-elasticsearch
echo 'deb https://artifacts.elastic.co/packages/oss-6.x/apt stable main' > /etc/apt/sources.list.d/elastic.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 68818C72E52529D4
echo 'deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse' > /etc/apt/sources.list.d/mongodb-org.list
apt-get update

# Install Java
apt-get install -y openjdk-8-jre

# Install MongoDB
apt-get install -y mongodb-org

# Install Elasticsearch
apt-get install -y elasticsearch-oss

# Install Graylog server
wget -nv -O /tmp/graylog-repo.deb https://packages.graylog2.org/repo/packages/graylog-3.3-repository_latest.deb
dpkg -i /tmp/graylog-repo.deb
rm -f /tmp/graylog-repo.deb
apt-get update
apt-get install graylog-server=${PACKAGE_VERSION}
apt-get install graylog-enterprise-plugins=${PACKAGE_VERSION}
apt-get install graylog-integrations-plugins=${PACKAGE_VERSION}
apt-get install graylog-enterprise-integrations-plugins=${PACKAGE_VERSION}

# Install Nginx
apt-get install -y nginx

# configure Elasticsearch
sed -i 's/#cluster.name.*/cluster.name: graylog/g' /etc/elasticsearch/elasticsearch.yml
echo 'action.auto_create_index: false' >> /etc/elasticsearch/elasticsearch.yml

# Prepare Graylog configuration for first boot
touch /var/lib/graylog-server/firstboot

# Graylog configuration script
cat << EOF > /etc/rc.local
#!/bin/bash

# wait for getting an IP address
for i in \`seq 1 10\`; do
  if [ \$(ip -o address show 2> /dev/null | grep -v '1: lo' | wc -l) -ne 0 ]; then
    break
  fi
  sleep 1
done

if [ -f /var/lib/graylog-server/firstboot ]; then
  echo 'Preparing Graylog...'
  PASSWORD_SECRET=\`pwgen -N 1 -s 96\`
  ADMIN_PASSWORD=\`pwgen -N 1 -B -v -s 8\`
  ADMIN_PASSWORD_SHA=\`echo -n \${ADMIN_PASSWORD} | shasum -a 256 | cut -d ' ' -f1\`
  sed -i "s/password_secret =/password_secret = \${PASSWORD_SECRET}/g" /etc/graylog/server/server.conf
  sed -i "s/root_password_sha2 =/root_password_sha2 = \${ADMIN_PASSWORD_SHA}/g" /etc/graylog/server/server.conf
  sed -i "s\#http_bind_address = 127.0.0.1:9000$\http_bind_address = 0.0.0.0:9000\g" /etc/graylog/server/server.conf
  systemctl enable mongod.service
  systemctl start mongod.service
  systemctl enable elasticsearch.service
  systemctl start elasticsearch.service
  systemctl enable graylog-server.service
  systemctl restart graylog-server.service

  IP=\`echo -n \$(hostname -I|awk '{print $1}') | sed 's/^ *//;s/ *\$//'\`
  if [ -z "\$IP" ]; then
    echo "Your appliance came up without a configured IP address. Graylog is probably not running correctly!" > /etc/issue
    echo " Shell login: ubuntu:ubuntu" >> /etc/issue
  else
    echo "Open http://\$IP in your browser to access Graylog." > /etc/issue
    echo "Write down the following passwords, they appear only once after the first boot." >> /etc/issue
    echo " Web login: admin:\${ADMIN_PASSWORD}" >> /etc/issue
    echo " Shell login: ubuntu:ubuntu" >> /etc/issue
  fi

  cat << EOHEADER > /etc/update-motd.d/00-header
#!/bin/sh
DISTRIB_DESCRIPTION="Graylog"

printf "Welcome to %s (%s %s %s)\n" "\\\$DISTRIB_DESCRIPTION" "$(uname -o)" "$(uname -r)" "$(uname -m)"
EOHEADER

  cat << EOHELP > /etc/update-motd.d/10-help-text
#!/bin/bash

URL="http://docs.graylog.org/en/latest/pages/installation/virtual_machine_appliances.html"

printf "\n Documentation:  %s\n" "\\\$URL"
EOHELP

  rm -f /etc/update-motd.d/50-landscape-sysinfo
  rm -f /etc/update-motd.d/50-motd-news
  rm -f /etc/update-motd.d/51-cloudguest
  rm -f /etc/update-motd.d/91-release-upgrade
  rm -f /var/lib/graylog-server/firstboot
else
  echo "Graylog Appliance" > /etc/issue
fi
exit 0
EOF

chmod +x /etc/rc.local

# adopt netplan for vmware interface name
cat << EOF > /etc/netplan/01-netcfg.yaml
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: yes
    ens160:
      dhcp4: yes
EOF

netplan generate
netplan apply

# Configure graylog-server overrides
mkdir -p /etc/systemd/system/graylog-server.service.d
cat << EOF > /etc/systemd/system/graylog-server.service.d/10-after_services.conf
[Unit]
After=network-online.target elasticsearch.service mongod.service
EOF

# Configure nginx
cat << EOF > /usr/share/nginx/html/502.html
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<title>Graylog is currently not reachable</title>
<style>
<!--
        body {font-family: arial,sans-serif}
        img { border:none; }
//-->
</style>
</head>
<body>
<blockquote>
        <h2>Graylog is currently not reachable...</h2>
        <p>There is either no Graylog web application running or it's not reachable by your browser. Please reload this page in case the application needs some more time to start up. If your appliance is only reachable by a virtual IP or it's behind a proxy, check the <code>http_*_uri</code> settings in the Graylog server.conf file. For further reading check the online documentation:
        <ul>
                <li><b>Getting started</b> - <a href="http://docs.graylog.org/en/latest/pages/getting_started/configure.html">http://docs.graylog.org/en/latest/pages/getting_started/configure.html</a></li>
                <li><b>Web interface</b> -  <a href="http://docs.graylog.org/en/latest/pages/configuration/web_interface.html">http://docs.graylog.org/en/latest/pages/configuration/web_interface.html</a></li>
                <li><b>Ask the community</b> - <a href="https://community.graylog.org/">https://community.graylog.org/</a></li>
        </ul>
</blockquote>
</body>
</html>
EOF

cat << EOF > /etc/nginx/sites-available/default
server {
      listen 80;
      location / {
        proxy_pass http://127.0.0.1:9000/;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass_request_headers on;
        proxy_connect_timeout 150;
        proxy_send_timeout 100;
        proxy_read_timeout 100;
        proxy_buffering off;
        client_max_body_size 8m;
        client_body_buffer_size 128k;
        expires off;
      }
      error_page 502 /502.html;
      location  /502.html {
        internal;
      }
}
EOF
