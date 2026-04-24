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
    libssl3 \
    zlib1g \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/telegram-bot-api/bin/telegram-bot-api /usr/local/bin/telegram-bot-api

RUN useradd -r -m -d /var/lib/telegram-bot-api -s /usr/sbin/nologin telegram-bot-api

WORKDIR /var/lib/telegram-bot-api
USER telegram-bot-api
EXPOSE 8081

ENTRYPOINT ["/usr/local/bin/telegram-bot-api"]
CMD ["--http-port=8081", "--dir=/var/lib/telegram-bot-api"]
