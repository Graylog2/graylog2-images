#!/usr/bin/env bash
#
# Configure graylog based on friendly environment variable.
#

set -e

source "/usr/share/graylog/data/config/scripts/global.sh"

# Overwrite default http timeout
update_config "http_connect_timeout" "10s"

update_config "password_secret" "${GRAYLOG_SERVER_SECRET:=$(pwgen -s 96)}"
update_config "rest_listen_uri" "http://0.0.0.0:12900/"
update_config "web_listen_uri" "http://0.0.0.0:9000/"
update_config "elasticsearch_network_host" "0.0.0.0"


if [ ! -z "${GRAYLOG_IS_MASTER}" ]; then
    update_config "is_master" "${GRAYLOG_IS_MASTER}"
fi

if [ ! -z "${GRAYLOG_PASSWORD}" ]; then
    update_config "root_password_sha2" "$(echo -n ${GRAYLOG_PASSWORD} | sha256sum | awk '{print $1}')"
fi

if [ ! -z "${GRAYLOG_SMTP_SERVER}" ]; then
    update_config "transport_email_enabled" "true"
    update_config "transport_email_use_auth" "true"
    update_config "transport_email_use_tls" "true"
    update_config "transport_email_use_ssl" "true"
    update_config "transport_email_subject_prefix" "[graylog]"
    update_config "transport_email_hostname" "${GRAYLOG_SMTP_SERVER}"
fi

if [ ! -z "${GRAYLOG_SMTP_PORT}" ]; then
    update_config "transport_email_port" "${GRAYLOG_SMTP_PORT}"
fi
if [ ! -z "${GRAYLOG_SMTP_USER}" ]; then
    update_config "transport_email_auth_username" "${GRAYLOG_SMTP_USER}"
fi
if [ ! -z "${GRAYLOG_SMTP_PASSWORD}" ]; then
    update_config "transport_email_auth_password" "${GRAYLOG_SMTP_PASSWORD}"
fi

if [ ! -z "${GRAYLOG_ES_SHARDS}" ]; then
    update_config "elasticsearch_shards" "${GRAYLOG_ES_SHARDS}"
fi

if [ ! -z "${GRAYLOG_ES_REPLICAS}" ]; then
    update_config "elasticsearch_replicas" "${GRAYLOG_ES_REPLICAS}"
fi

if [ ! -z "${GRAYLOG_ES_PREFIX}" ]; then
    update_config "elasticsearch_index_prefix" "${GRAYLOG_ES_PREFIX}"
fi

if [ ! -z "${GRAYLOG_ES_CLUSTER}" ]; then
    update_config "elasticsearch_cluster_name" "${GRAYLOG_ES_CLUSTER}"
fi

if [ ! -z "${GRAYLOG_ES_NODES}" ]; then
    update_config "elasticsearch_discovery_zen_ping_multicast_enabled" "false"
    update_config "elasticsearch_discovery_zen_ping_unicast_hosts" "${GRAYLOG_ES_NODES}"
fi

if [ ! -z "${GRAYLOG_MONGO_URI}" ]; then
    update_config "mongodb_uri" "${GRAYLOG_MONGO_URI}"
fi

# Set heap to different value if specified
if [ ! -z "${GRAYLOG_MEMORY}" ]; then
    export GRAYLOG_SERVER_JAVA_OPTS="-Xms1g -Xmx${GRAYLOG_MEMORY} -XX:NewRatio=1 -server -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:-OmitStackTraceInFastThrow"
fi

# Logging options
if [ ! -z "${GRAYLOG_LOGLEVEL}" ]; then
    update_loglevel "${GRAYLOG_LOGLEVEL}"
fi

# MaxMind db download URL for geolocation support
if [ ! -z "${MAXMIND_DB_URL}" ]; then
    cd /tmp
    wget -q "${MAXMIND_DB_URL}"
    filename="$(basename "${MAXMIND_DB_URL}")"
    echo "Downloaded Maxmind DB - ${filename}"
    if [ ${filename: -3} == ".gz" ]; then
        gzip -d "${filename}"
        echo "Decompressed Maxmind DB file - ${filename}"
    fi
    # Move db file to configured location
    if [ ! -z "${GEOLOCATION_PATH}" ]; then
        mv "${filename%.gz}" "${GEOLOCATION_PATH}"
        echo "Moved maxmind DB to location ${GEOLOCATION_PATH}"
    fi
fi
