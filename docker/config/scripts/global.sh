#!/usr/bin/env bash
#
# Global variable and functions for scripts
#

set -e

CONFIG_FILE="/usr/share/graylog/data/config/graylog.conf"
ELASTICSEARCH_YML_FILE="/usr/share/graylog/data/config/elasticsearch.yml"
LOG4J_FILE="/usr/share/graylog/data/config/log4j2.xml"

update_config() {
    ckey="${1}"
    cvalue="${2}"
    if grep "^\s*${ckey}\s*=.*$" ${CONFIG_FILE} >/dev/null; then
        sed -i -e "s|^\s*${ckey}\s*=.*$|${ckey} = ${cvalue}|" ${CONFIG_FILE}
    elif grep "^\s*#\s*${ckey}\s*=.*$" ${CONFIG_FILE} >/dev/null; then
        sed -i -e "0,/^\s*#\s*${ckey}\s*=.*$/s||${ckey} = ${cvalue}|" ${CONFIG_FILE}
    else
        echo "${ckey} = ${cvalue}" >> ${CONFIG_FILE}
    fi
}

get_config() {
    # echo the value of config if it is defined
    ckey="${1}"
    grep "^\s*${ckey}\s*=.*$" ${CONFIG_FILE} | sed -e "s|^\s*${ckey}\s*=\(.*\)$|\1|" -e "s|^\s*||" -e "s|\s*$||"
}

update_loglevel() {
    loglevel="${1}"
    name="${2}"
    if [ "X${loglevel}" == "X" ]; then
        echo "ERROR - loglevel not specified!"
        exit 1
    fi
    if [ "X${name}" == "X" ]; then
        sed -i 's/ level="[^"]*"/ level="'"${loglevel}"'"/g' "${LOG4J_FILE}"
    else
        sed -i 's/name="'"${name}"'"\s* level="[^"]*"/name="'"${name}"'" level="'"${loglevel}"'"/g' "${LOG4J_FILE}"
    fi
}
