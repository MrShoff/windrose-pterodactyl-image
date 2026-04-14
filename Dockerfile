FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        unzip \
        tar \
        wget \
        jq \
        procps \
        xvfb \
        xauth \
        wine \
        wine32:i386 \
        wine64 \
    && rm -rf /var/lib/apt/lists/*

# Install .NET runtime for DepotDownloader
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --channel 8.0 --runtime dotnet --install-dir /usr/share/dotnet \
    && ln -sf /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm -f /tmp/dotnet-install.sh

# Install DepotDownloader
ARG DEPOT_DOWNLOADER_VERSION=3.4.0
RUN curl -fsSL \
      "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_${DEPOT_DOWNLOADER_VERSION}/DepotDownloader-linux-x64.zip" \
      -o /tmp/depotdownloader.zip \
    && mkdir -p /opt/depotdownloader \
    && unzip /tmp/depotdownloader.zip -d /opt/depotdownloader \
    && chmod +x /opt/depotdownloader/DepotDownloader \
    && rm -f /tmp/depotdownloader.zip

# Pterodactyl-required runtime user
RUN useradd -m -d /home/container -s /bin/bash container

USER container
ENV USER=container
ENV HOME=/home/container
WORKDIR /home/container

COPY --chown=container:container entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
