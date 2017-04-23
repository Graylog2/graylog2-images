#!/usr/bin/env bash
#
# Auto-configure graylog config if mongodb and elasticsearch docker containers
# are linked
#

set -e

source "/usr/share/graylog/data/config/scripts/global.sh"

if [ ! -z "${MONGO_PORT_27017_TCP_ADDR}" ] && [ ! -z "${MONGO_PORT_27017_TCP_PORT}" ]; then
    sed -i -e "s\mongodb_uri =.*$\mongodb_uri = mongodb://${MONGO_PORT_27017_TCP_ADDR}:${MONGO_PORT_27017_TCP_PORT}/graylog\\" ${CONFIG_FILE}
fi

if [ ! -z "${ELASTICSEARCH_PORT_9300_TCP_ADDR}" ] && [ ! -z "${ELASTICSEARCH_PORT_9300_TCP_PORT}" ]; then
    update_config "elasticsearch_discovery_zen_ping_multicast_enabled" "false"
    update_config "elasticsearch_discovery_zen_ping_unicast_hosts" "${ELASTICSEARCH_PORT_9300_TCP_ADDR}:${ELASTICSEARCH_PORT_9300_TCP_PORT}"
    update_config "elasticsearch_config_file" "${ELASTICSEARCH_YML_FILE}"
    update_config "elasticsearch_cluster_name" "elasticsearch"

    # Create elasticsearch.yml file
    cat > ${ELASTICSEARCH_YML_FILE} <<-EOF
		cluster.name: elasticsearch
		node.master: false
		node.data: false
		transport.tcp.port: 9350
		http.enabled: false
		discovery.zen.ping.multicast.enabled: false
EOF
    echo "discovery.zen.ping.unicast.hosts: [\"${ELASTICSEARCH_PORT_9300_TCP_ADDR}:${ELASTICSEARCH_PORT_9300_TCP_PORT}\"]" >> ${ELASTICSEARCH_YML_FILE}

fi
