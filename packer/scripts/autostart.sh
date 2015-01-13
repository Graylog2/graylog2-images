cat > /etc/rc.local <<'EOF'
#!/bin/sh -e

IP=$(hostname -I)
echo "Open http://$IP in your browser to access Graylog. Default username/password: 'admin'" > /etc/issue

if [ ! -d "/etc/graylog2" ]; then
        /usr/bin/graylog2-ctl reconfigure
fi
exit 0
EOF
