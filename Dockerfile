FROM indifferentbroccoli/windrose-server-docker:latest

USER root

RUN id -u container >/dev/null 2>&1 || useradd -m -d /home/container -s /bin/bash container \
    && mkdir -p /home/container \
    && chown -R container:container /home/container \
    && rm -rf /home/steam/server-files \
    && ln -s /home/container /home/steam/server-files

ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD []
