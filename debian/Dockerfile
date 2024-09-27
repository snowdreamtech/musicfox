FROM snowdreamtech/build-essential:bookworm AS builder

ENV MUSICFOX_VERSION=4.5.3 \
    MUSICFOX_ROOT="/root/.config/go-musicfox" \
    GO111MODULE=on \
    GOPROXY=https://proxy.golang.org,https://goproxy.io,direct

RUN mkdir /workspace

WORKDIR /workspace

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    -t bookworm-backports golang-1.22=1.22.7-1~bpo12+1 \
    libflac-dev \
    libasound2-dev \ 
    && wget -c https://github.com/go-musicfox/go-musicfox/archive/refs/tags/v${MUSICFOX_VERSION}.tar.gz  \ 
    && tar zxvf v${MUSICFOX_VERSION}.tar.gz  \ 
    && cd go-musicfox-${MUSICFOX_VERSION}  \ 
    && go mod download \
    && make \
    && cp ./bin/musicfox /workspace/ \
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*



FROM snowdreamtech/debian:12.7.0

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="musicfox Image Based On Debian" \
    org.opencontainers.image.description="Docker Images for musicfox on Debian. (i386,amd64,arm32v5,arm32v7,arm64,mips64le,ppc64le,s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/musicfox" \
    org.opencontainers.image.base.name="snowdreamtech/musicfox:debian" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/musicfox" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="4.5.3" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/musicfox"

# keep the docker container running
ENV KEEPALIVE=1

RUN set -eux \
    && apt-get -qqy update  \
    && apt-get -qqy install --no-install-recommends \ 
    libflac-dev \
    libasound2-dev \ 
    && apt-get -qqy --purge autoremove \
    && apt-get -qqy clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

COPY --from=builder /workspace/musicfox /usr/local/bin

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]