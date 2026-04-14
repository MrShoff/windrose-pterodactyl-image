#!/bin/bash
set -e

cd /home/container

# Expand Pterodactyl variables from the egg STARTUP string.
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Hand off to the upstream init/start script if needed.
# For Windrose specifically, the upstream image uses its own init script.
exec /home/steam/server/init.sh
