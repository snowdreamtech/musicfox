FROM snowdreamtech/build-essential:3.20.2 AS builder

ENV MUSICFOX_VERSION=4.5.3 \
    MUSICFOX_ROOT="/root/.config/go-musicfox" \
    GO111MODULE=on \
    GOPROXY=https://proxy.golang.org,https://goproxy.io,direct

RUN mkdir /workspace

WORKDIR /workspace

RUN apk add --no-cache go=1.22.6-r0 \
    bash=5.2.26-r0 \
    flac-dev=1.4.3-r1 \
    alsa-lib-dev=1.2.11-r0 \ 
    && wget -c https://github.com/go-musicfox/go-musicfox/archive/refs/tags/v${MUSICFOX_VERSION}.tar.gz  \ 
    && tar zxvf v${MUSICFOX_VERSION}.tar.gz  \ 
    && cd go-musicfox-${MUSICFOX_VERSION}  \ 
    && go mod download \
    && make \
    && cp ./bin/musicfox /workspace/




FROM snowdreamtech/alpine:3.20.2

LABEL maintainer="snowdream <sn0wdr1am@qq.com>"

# keep the docker container running
ENV KEEPALIVE=0

RUN apk add --no-cache flac-dev=1.4.3-r1 \
    alsa-lib-dev=1.2.11-r0 

COPY --from=builder /workspace/musicfox /usr/local/bin

ENTRYPOINT [  "sh", "-c", "musicfox" ]