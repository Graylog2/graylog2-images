cat > /etc/rc.local <<'EOF'
#!/bin/sh -e

IP=$(hostname -I|awk '{print $1}')
if [ -z "$IP" ]; then
  echo "Your appliance came up without a configured IP address. Graylog is probable not running correctly!" > /etc/issue
else
  echo "Open http://$IP in your browser to access Graylog.\nLogin to the web interface with username/password: 'admin'.\nOr try the console here with username/password: 'ubuntu'." > /etc/issue
fi

if [ ! -d "/etc/graylog" ]; then
        /usr/bin/graylog-ctl reconfigure
fi
exit 0
EOF

cat > /etc/update-motd.d/00-header <<'EOF'
#!/bin/sh

DISTRIB_DESCRIPTION="Graylog"

printf "Welcome to %s (%s %s %s)\n" "$DISTRIB_DESCRIPTION" "$(uname -o)" "$(uname -r)" "$(uname -m)"
EOF

cat > /etc/update-motd.d/10-help-text <<'EOF'
#!/bin/sh

URL="http://docs.graylog.org/en/latest/pages/installation.html#virtual-machine-appliances"

printf "\n * Documentation:  %s\n" "$URL"
EOF
rm -f /etc/update-motd.d/91-release-upgrade
