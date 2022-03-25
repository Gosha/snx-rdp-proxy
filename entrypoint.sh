#!/bin/bash
REMOTE_PORT=${REMOTE_PORT:-3389}

function prepend() {
    while read -r line; do
        echo "$1 $line"
    done
}

function wait-for-tunsnx() {
    while ! ip addr show dev tunsnx > /dev/null 2>&1; do
        sleep 1
    done
}

socat -d -d TCP4-LISTEN:3389,fork,reuseaddr "TCP4:${REMOTE_HOST:?Missing REMOTE_HOST}:${REMOTE_PORT}" 2>&1 | prepend "SOCAT:" &

trap "echo Stopping; exit 0" SIGTERM SIGINT

wait-for-tunsnx && /usr/sbin/danted -f /etc/danted.conf | prepend "DANTE:" &

snxconnect ${DEBUG:+-D} \
    -H access.svea.com \
    -F Login/Login \
    -R ssl_vpn_Svea_VPN_Login \
    -E SNX/extender \
    -U "${USERNAME:?Missing username}" \
    ${SAVE_COOKIES:+ -c /data/cookies --save-cookies} \
    ${PASSWORD:+ -P "$PASSWORD"} &

wait $!
