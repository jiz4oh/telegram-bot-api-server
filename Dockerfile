# syntax=docker/dockerfile:1.7

FROM debian:bookworm-slim AS builder
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    cmake \
    gperf \
    libssl-dev \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build/source
COPY source/ /build/source/

RUN cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/opt/telegram-bot-api

RUN cmake --build build --target install -j"$(nproc)"

FROM debian:bookworm-slim
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    iptables \
    libssl3 \
    zlib1g \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/telegram-bot-api/bin/telegram-bot-api /usr/local/bin/telegram-bot-api
COPY scripts/start-telegram-bot-api-proxy.sh /usr/local/bin/start-telegram-bot-api-proxy.sh

RUN useradd -r -m -d /var/lib/telegram-bot-api -s /usr/sbin/nologin telegram-bot-api
ARG GOST_VERSION=v2.12.0
ARG TARGETARCH=amd64
RUN set -eux; \
    GOST_NUM="${GOST_VERSION#v}"; \
    curl -fsSL -o /tmp/gost.tar.gz \
      "https://github.com/ginuerzh/gost/releases/download/${GOST_VERSION}/gost_${GOST_NUM}_linux_${TARGETARCH}.tar.gz"; \
    tar -xzf /tmp/gost.tar.gz -C /usr/local/bin; \
    chmod 755 /usr/local/bin/gost /usr/local/bin/start-telegram-bot-api-proxy.sh; \
    rm /tmp/gost.tar.gz

WORKDIR /var/lib/telegram-bot-api

# The transparent redirector installs iptables rules before launching the API.
USER root
EXPOSE 8081

ENTRYPOINT ["/usr/local/bin/start-telegram-bot-api-proxy.sh"]
CMD ["--http-port=8081", "--dir=/var/lib/telegram-bot-api"]
