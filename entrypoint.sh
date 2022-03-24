#!/bin/bash
REMOTE_PORT=${REMOTE_PORT:-3389}

socat -d -d TCP4-LISTEN:3389,fork,reuseaddr "TCP4:${REMOTE_HOST:?Missing REMOTE_HOST}:${REMOTE_PORT}" &

trap "echo Stopping; exit 0" SIGTERM SIGINT

snxconnect ${DEBUG:+-D} \
    -H access.svea.com \
    -F Login/Login \
    -R ssl_vpn_Svea_VPN_Login \
    -E SNX/extender \
    -U "${USERNAME:?Missing username}" \
    ${PASSWORD:+ -P "$PASSWORD"} &

wait $!
