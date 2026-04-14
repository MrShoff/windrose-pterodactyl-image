FROM indifferentbroccoli/windrose-server-docker:latest

USER root

# Create the required Pterodactyl user and home.
RUN id -u container >/dev/null 2>&1 || useradd -m -d /home/container -s /bin/bash container \
    && mkdir -p /home/container \
    && chown -R container:container /home/container

# Bridge the upstream server-files path to the Pterodactyl data path.
RUN rm -rf /home/steam/server-files \
    && ln -s /home/container /home/steam/server-files

# Optional but recommended: keep a consistent environment.
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Put our wrapper entrypoint in place.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD []
