#!/usr/bin/env bash
#
# Configure minute details in graylog config using env variables with GL_CONF_
# prefix
#

set -e

source "/usr/share/graylog/data/config/scripts/global.sh"

# Identify all env variables with GL_CONF_ prefix and update config
for VAR in $(env); do
    if [[ $VAR =~ ^GL_CONF_ ]]; then
        gl_conf_name="$(echo "$VAR" | sed -r 's/^GL_CONF_([^=]*)=.*/\1/' | sed -e 's/__/./g' -e "s|^\s*||" -e "s|\s*$||" | tr '[:upper:]' '[:lower:]')"
        gl_conf_value="$(echo "$VAR" | sed -r -e "s/^[^=]*=(.*)/\1/" -e "s|^\s*||" -e "s|\s*$||")"
        update_config "${gl_conf_name}" "${gl_conf_value}"
    fi
done

# Identify all env variables with GL_LOGLEVEL_ prefix and logging config
for VAR in $(env); do
    if [[ $VAR =~ ^GL_LOGLEVEL_ ]]; then
        gl_loglevel_name="$(echo "$VAR" | sed -r 's/^GL_LOGLEVEL_([^=]*)=.*/\1/' | sed -e 's/__/./g' -e "s|^\s*||" -e "s|\s*$||" | tr '[:upper:]' '[:lower:]')"
        gl_loglevel_value="$(echo "$VAR" | sed -r -e "s/^[^=]*=(.*)/\1/" -e "s|^\s*||" -e "s|\s*$||")"
        update_loglevel "${gl_loglevel_value}" "${gl_loglevel_name}"
    fi
done
