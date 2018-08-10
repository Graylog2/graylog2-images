#!/bin/bash

set -x

if [ -z "$PACKAGE_VERSION" ] ; then
  echo "No Git tag nor Omnibus version set, exiting."
  exit 1
fi
echo "Building image for Graylog $PACKAGE_VERSION"

# Update repositories
apt-get update
apt-get dist-upgrade -y
# Install tools needed for installation
apt-get install -y apt-transport-https curl wget rsync vim man sudo avahi-autoipd pwgen uuid-runtime gnupg
apt-get install -y tzdata ntp ntpdate

# Prepare repositories
apt-key adv --fetch-keys https://artifacts.elastic.co/GPG-KEY-elasticsearch
echo 'deb https://artifacts.elastic.co/packages/5.x/apt stable main' > /etc/apt/sources.list.d/elastic.list
apt-get update

# Install Java
apt-get install -y openjdk-8-jre

# Install MongoDB
apt-get install -y mongodb

# Install Elasticsearch
apt-get install -y elasticsearch

# Install Graylog server
wget -nv -O /tmp/graylog-repo.deb https://packages.graylog2.org/repo/packages/graylog-2.4-repository_latest.deb
dpkg -i /tmp/graylog-repo.deb
rm -f /tmp/graylog-repo.deb
apt-get update
apt-get install graylog-server=${PACKAGE_VERSION}

# configure Elasticsearch
sed -i 's/#cluster.name.*/cluster.name: graylog/g' /etc/elasticsearch/elasticsearch.yml
systemctl enable elasticsearch.service

# Prepare Graylog configuration for first boot
touch /var/lib/graylog-server/firstboot

# Graylog configuration script
cat << EOF > /etc/rc.local
#!/bin/bash

if [ -f /var/lib/graylog-server/firstboot ]; then
  echo 'Preparing Graylog...'
  PASSWORD_SECRET=\`pwgen -N 1 -s 96\`
  ADMIN_PASSWORD=\`pwgen -N 1 -B -v -s 8\`
  ADMIN_PASSWORD_SHA=\`echo -n \${ADMIN_PASSWORD} | shasum -a 256 | cut -d ' ' -f1\`
  sed -i "s/password_secret =/password_secret = \${PASSWORD_SECRET}/g" /etc/graylog/server/server.conf
  sed -i "s/root_password_sha2 =/root_password_sha2 = \${ADMIN_PASSWORD_SHA}/g" /etc/graylog/server/server.conf
  sed -i "s\rest_listen_uri = http://127.0.0.1:9000/api/$\rest_listen_uri = http://0.0.0.0:9000/api/\g" /etc/graylog/server/server.conf
  sed -i "s\#web_listen_uri = http://127.0.0.1:9000/$\web_listen_uri = http://0.0.0.0:9000/\g" /etc/graylog/server/server.conf
  systemctl enable graylog-server.service
  systemctl restart graylog-server.service


  for i in \`seq 1 10\`; do

  if [ \$(ip -o address show 2> /dev/null | grep -v '1: lo' | wc -l) -ne 0 ]; then
     break
  fi
  sleep 1
  done

  IP=\`echo -n \$(hostname -I|awk '{print $1}') | sed 's/^ *//;s/ *\$//'\`
  if [ -z "\$IP" ]; then
    echo "Your appliance came up without a configured IP address. Graylog is probably not running correctly!" > /etc/issue
    echo " Shell login: ubuntu:ubuntu" >> /etc/issue
  else
    echo "Open http://\$IP:9000 in your browser to access Graylog." > /etc/issue
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
printf "\nFor accessing Graylog behind a virtual IP change the web_endpoint_uri config option in /etc/graylog/server/server.conf accordingly and restart Graylog.\n\n"
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
