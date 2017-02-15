#!/usr/bin/env bash
#
# Configure elasticsearch based on info from server.conf
#

set -e

source "/usr/share/graylog/data/config/scripts/global.sh"

es_config_path="$(get_config elasticsearch_config_file)"
if [ "X${es_config_path}" == "X" ]; then
    es_config_path="${ELASTICSEARCH_YML_FILE}"
    update_config "elasticsearch_config_file" "${ELASTICSEARCH_YML_FILE}"
fi

es_dir_path="$(dirname ${es_config_path})"
if [ ! -d "${es_dir_path}" ]; then
    mkdir -p "${es_dir_path}"
fi

if [ ! -f "${es_config_path}" ]; then
    echo "cluster.name: $(get_config elasticsearch_cluster_name)" > "${es_config_path}"
    echo "node.master: false" >> "${es_config_path}"
    echo "node.data: false" >> "${es_config_path}"
    if [ "X${HOST}" != "X" ]; then
        echo "transport.tcp.port: ${PORT2}" >> "${es_config_path}"
    else
        echo "transport.tcp.port: 9350" >> "${es_config_path}"
    fi
    echo "http.enabled: false" >> "${es_config_path}"
    echo "discovery.zen.ping.multicast.enabled: false" >> "${es_config_path}"
    echo "discovery.zen.ping.unicast.hosts: $(get_config elasticsearch_discovery_zen_ping_unicast_hosts)" >> "${es_config_path}"
    if [ "X${HOST}" != "X" ]; then
        echo "network.bind_host: 0.0.0.0" >> "${es_config_path}"
        echo "network.host: $(dig +short "${HOST}")" >> "${es_config_path}"
    fi
    if [ ! -z "${ES_INDEX_REFRESH_INTERVAL}" ]; then
        echo "index.refresh_interval: ${ES_INDEX_REFRESH_INTERVAL}" >> "${es_config_path}"
    fi
fi
