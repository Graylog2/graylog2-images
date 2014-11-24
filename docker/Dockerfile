FROM phusion/baseimage:0.9.15
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y curl

RUN curl -s -L -O https://packages.graylog2.org/releases/graylog2-omnibus/ubuntu/graylog2_latest.deb

RUN dpkg -i graylog2_latest.deb && \
rm graylog2_latest.deb

EXPOSE 12900
CMD /opt/graylog2/embedded/bin/runsvdir-docker & graylog2-ctl set-admin-password $GRAYLOG2_PASSWORD & graylog2-ctl reconfigure && tail -f /var/log/graylog2/server/current
