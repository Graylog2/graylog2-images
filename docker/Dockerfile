FROM phusion/baseimage:0.9.15
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl ntp ntpdate tzdata && \
    curl -O -L https://packages.graylog2.org/releases/graylog2-omnibus/ubuntu/graylog_latest.deb && \
    dpkg -i graylog_latest.deb && \
    rm graylog_latest.deb && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/*

VOLUME /var/opt/graylog/data
VOLUME /var/log/graylog
VOLUME /opt/graylog/plugin

# web interface
EXPOSE 9000
# gelf tcp
EXPOSE 12201
# gelf udp
EXPOSE 12201/udp
# rest api
EXPOSE 12900
# etcd
EXPOSE 4001
# syslog
EXPOSE 514
EXPOSE 514/udp

CMD /opt/graylog/embedded/bin/runsvdir-docker & \
    if [ ! -z "$GRAYLOG_PASSWORD" ]; then graylog-ctl set-admin-password $GRAYLOG_PASSWORD; fi && \
    if [ ! -z "$GRAYLOG_TIMEZONE" ]; then graylog-ctl set-timezone $GRAYLOG_TIMEZONE; fi && \
    if [ ! -z "$GRAYLOG_SMTP_SERVER" ]; then graylog-ctl set-email-config $GRAYLOG_SMTP_SERVER; fi && \
    if [ ! -z "$GRAYLOG_MASTER" ]; then graylog-ctl local-connect && graylog-ctl set-cluster-master $GRAYLOG_MASTER; fi && \
    if [ ! -z "$GRAYLOG_WEB" ]; then graylog-ctl reconfigure-as-webinterface; \
    elif [ ! -z "$GRAYLOG_SERVER" ]; then graylog-ctl reconfigure-as-backend; else \
      graylog-ctl local-connect && graylog-ctl reconfigure; fi && \
    tail -F /var/log/graylog/server/current /var/log/graylog/web/current
