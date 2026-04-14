#!/bin/bash
set -euo pipefail

cd /home/container

# Standard Pterodactyl startup expansion
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Set sane Wine defaults
export WINEPREFIX="${WINEPREFIX:-/home/container/.wine}"
export WINEARCH="${WINEARCH:-win64}"
export WINEDEBUG="${WINEDEBUG:-fixme-all}"

# Bootstrap Wine prefix once
if [ ! -f "${WINEPREFIX}/system.reg" ]; then
    echo "Initializing Wine prefix..."
    xvfb-run --auto-servernum bash -lc 'wineboot --init >/dev/null 2>&1'
fi

exec bash -lc "${MODIFIED_STARTUP}"
