FROM phusion/baseimage:0.9.15
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl ntp ntpdate tzdata && \
    curl -O -L https://packages.graylog2.org/releases/graylog2-omnibus/ubuntu/graylog2_latest.deb && \
    dpkg -i graylog2_latest.deb && \
    rm graylog2_latest.deb && \
    apt-get clean && \
    rm -rf /tmp/* /var/tmp/*

VOLUME /var/opt/graylog2/data
VOLUME /var/log/graylog2

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

CMD /opt/graylog2/embedded/bin/runsvdir-docker & \
    if [ ! -z "$GRAYLOG2_PASSWORD" ]; then graylog2-ctl set-admin-password $GRAYLOG2_PASSWORD; fi && \
    if [ ! -z "$GRAYLOG2_TIMEZONE" ]; then graylog2-ctl set-timezone $GRAYLOG2_TIMEZONE; fi && \
    if [ ! -z "$GRAYLOG2_SMTP_SERVER" ]; then graylog2-ctl set-email-config $GRAYLOG2_SMTP_SERVER; fi && \
    if [ ! -z "$GRAYLOG2_MASTER" ]; then graylog2-ctl local-connect && graylog2-ctl set-cluster-master $GRAYLOG2_MASTER; fi && \
    if [ ! -z "$GRAYLOG2_WEB" ]; then graylog2-ctl reconfigure-as-webinterface; \
    elif [ ! -z "$GRAYLOG2_SERVER" ]; then graylog2-ctl reconfigure-as-backend; else \
      graylog2-ctl local-connect && graylog2-ctl reconfigure; fi && \
    tail -F /var/log/graylog2/server/current /var/log/graylog2/web/current
