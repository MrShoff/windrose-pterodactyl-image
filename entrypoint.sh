#!/bin/bash
set -e

cd /home/container

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

exec /home/steam/server/init.sh
