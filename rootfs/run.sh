#!/usr/bin/with-contenv bashio
set -e

CONF=/etc/tinyproxy/tinyproxy.conf

PORT=$(bashio::config 'port')
LOG_LEVEL=$(bashio::config 'log_level')
MAX_CLIENTS=$(bashio::config 'max_clients')
TIMEOUT=$(bashio::config 'timeout')

{
    echo "User tinyproxy"
    echo "Group tinyproxy"
    echo "Port ${PORT}"
    echo "Listen 0.0.0.0"
    echo "Timeout ${TIMEOUT}"
    echo "MaxClients ${MAX_CLIENTS}"
    echo "LogLevel ${LOG_LEVEL}"

    if bashio::config.true 'disable_via_header'; then
        echo "DisableViaHeader Yes"
    fi

    # No Allow directives means tinyproxy accepts ALL clients
    for client in $(bashio::config 'allowed_clients'); do
        echo "Allow ${client}"
    done

    # No ConnectPort directives means CONNECT is allowed to any port
    for p in $(bashio::config 'connect_ports'); do
        echo "ConnectPort ${p}"
    done
} > "${CONF}"

if ! bashio::config.has_value 'allowed_clients'; then
    bashio::log.warning \
        "allowed_clients is empty — the proxy accepts connections from ANY client that can reach the host!"
fi

bashio::log.info "Starting tinyproxy on port ${PORT}"
exec tinyproxy -d -c "${CONF}"
