FROM phusion/baseimage:0.9.16
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl ntp ntpdate tzdata && \
    curl -O -L https://packages.graylog2.org/releases/graylog2-omnibus/ubuntu/graylog_beta.deb && \
    dpkg -i graylog_beta.deb && \
    rm graylog_beta.deb && \
    sed -i "0,/^\s*$/s//tail\ \-F\ \/var\/log\/graylog\/server\/current\ \&/" /etc/rc.local && \
    cp /opt/graylog/embedded/share/docker/01_run_graylogctl.sh /etc/my_init.d/ && \
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

CMD ["/opt/graylog/embedded/share/docker/my_init"]
