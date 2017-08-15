FROM java:8-jre-alpine

ARG GRAYLOG_VERSION

#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre
ENV GRAYLOG_SERVER_JAVA_OPTS "-Xms1g -Xmx2g -XX:NewRatio=1 -XX:MaxMetaspaceSize=256m -server -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:-OmitStackTraceInFastThrow"

RUN apk add --update su-exec openssl tar libcap \
  && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN set -x \
  && addgroup -g 1100 graylog \
  && adduser -D -s /sbin/nologin -u 1100 -G graylog graylog \
  && mkdir /usr/share/graylog \
  && wget -O /usr/share/graylog.tgz "https://packages.graylog2.org/releases/graylog/graylog-${GRAYLOG_VERSION}.tgz" \
  && tar xfz /usr/share/graylog.tgz --strip-components=1 -C /usr/share/graylog \
  && chown -R graylog:graylog /usr/share/graylog \
  && rm /usr/share/graylog.tgz \
  && setcap 'cap_net_bind_service=+ep' $JAVA_HOME/bin/java

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
