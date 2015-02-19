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
