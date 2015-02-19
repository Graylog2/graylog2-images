echo 'graylog' > /etc/hostname
cat > /etc/network/if-up.d/update_hosts <<'EOF'
#!/bin/bash

#/etc/network/if-up.d/update_hosts
set -e

#Variable IFACE is setup by Ubuntu network init scripts to whichever interface changed status.
[ "$IFACE" == "eth0" ] || exit

myname=`cat /etc/hostname`
shortname=`cat /etc/hostname | cut -d "." -f1`
hostsfile="/etc/hosts"
#Knock out line with "old" IP
sed -i '/ '$myname'/ d' $hostsfile
ipaddr=$(ifconfig eth0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
echo "$ipaddr $myname $shortname" >> $hostsfile
EOF
chmod +x /etc/network/if-up.d/update_hosts
sed -i 's/^preserve_hostname.*/preserve_hostname: true/' /etc/cloud/cloud.cfg

cat > /etc/environment <<'EOF'
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
LC_ALL="en_US.UTF-8"
EOF
