FROM java:8-jre-alpine

ARG GRAYLOG_VERSION
ARG GRAYLOG_AWS_PLUGIN_VERSION
ARG GRAYLOG_BEATS_PLUGIN_VERSION
ARG GRAYLOG_METRICS_PROM_PLUGIN_VERSION

#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre
ENV GRAYLOG_SERVER_JAVA_OPTS "-Xms1g -Xmx2g -XX:NewRatio=1 -XX:MaxMetaspaceSize=256m -server -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:-OmitStackTraceInFastThrow"
ENV GOSU_VERSION 1.7

RUN apk add --update su-exec openssl tar libcap \
  && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN set -x \
  && addgroup -g 1100 graylog \
  && adduser -D -s /sbin/nologin -u 1100 -G graylog graylog \
  && mkdir /usr/share/graylog \
  && wget -O /usr/share/graylog.tgz "https://packages.graylog2.org/releases/graylog/graylog-${GRAYLOG_VERSION}.tgz" \
  && tar xfz /usr/share/graylog.tgz --strip-components=1 -C /usr/share/graylog \
  && wget -O /usr/share/graylog/plugin/graylog-plugin-aws-${GRAYLOG_AWS_PLUGIN_VERSION}.jar https://github.com/graylog-labs/graylog-plugin-aws/releases/download/${GRAYLOG_AWS_PLUGIN_VERSION}/graylog-plugin-aws-${GRAYLOG_AWS_PLUGIN_VERSION}.jar \
  && wget -O /usr/share/graylog/plugin/graylog-plugin-beats-${GRAYLOG_BEATS_PLUGIN_VERSION}.jar https://github.com/sivasamyk/graylog-beats-plugin/releases/download/v${GRAYLOG_BEATS_PLUGIN_VERSION}/graylog-input-beats-${GRAYLOG_BEATS_PLUGIN_VERSION}.jar \
  && wget -O /usr/share/graylog/plugin/metrics-reporter-prometheus-${GRAYLOG_METRICS_PROM_PLUGIN_VERSION}.jar https://github.com/Graylog2/graylog-plugin-metrics-reporter/releases/download/${GRAYLOG_METRICS_PROM_PLUGIN_VERSION}/metrics-reporter-prometheus-${GRAYLOG_METRICS_PROM_PLUGIN_VERSION}.jar \
  && chown -R graylog:graylog /usr/share/graylog \
  && rm /usr/share/graylog.tgz \
  && setcap 'cap_net_bind_service=+ep' $JAVA_HOME/bin/java

RUN wget -O - http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz | gzip -d - > /tmp/GeoLite2-City.mmdb

ENV PATH /usr/share/graylog/bin:$PATH
WORKDIR /usr/share/graylog

RUN set -ex \
  && for path in \
    ./data/journal \
    ./data/log \
    ./data/config \
  ; do \
    mkdir -p "$path"; \
  done

COPY config ./data/config


VOLUME /usr/share/graylog/data

COPY docker-entrypoint.sh /

EXPOSE 9000 12900
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["graylog"]
