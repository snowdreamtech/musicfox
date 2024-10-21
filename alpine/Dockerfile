FROM snowdreamtech/build-essential:alpine3.20 AS builder

ENV MUSICFOX_VERSION=4.5.3 \
    MUSICFOX_ROOT="/root/.config/go-musicfox" \
    GO111MODULE=on \
    GOPROXY=https://proxy.golang.org,https://goproxy.io,direct

RUN mkdir /workspace

WORKDIR /workspace

RUN apk add --no-cache go=1.22.8-r0 \
    bash \
    flac-dev \
    alsa-lib-dev \ 
    && wget -c https://github.com/go-musicfox/go-musicfox/archive/refs/tags/v${MUSICFOX_VERSION}.tar.gz  \ 
    && tar zxvf v${MUSICFOX_VERSION}.tar.gz  \ 
    && cd go-musicfox-${MUSICFOX_VERSION}  \ 
    && go mod download \
    && make \
    && cp ./bin/musicfox /workspace/



FROM snowdreamtech/alpine:3.20.3

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="musicfox Image Based On Alpine" \
    org.opencontainers.image.description="Docker Images for musicfox on Alpine. (i386, amd64, arm32v6, arm32v7, arm64, ppc64le,riscv64, s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/musicfox" \
    org.opencontainers.image.base.name="snowdreamtech/musicfox:alpine" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/musicfox" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="4.5.3" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/musicfox"

# keep the docker container running
ENV KEEPALIVE=1

RUN apk add --no-cache flac-dev \
    alsa-lib-dev

COPY --from=builder /workspace/musicfox /usr/local/bin

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]