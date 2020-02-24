ARG ATHEME_UID=10000
ARG ATHEME_VERSION=7.2.10-r2
ARG BUILD_CONTRIB_MODULES=

FROM alpine:latest AS builder
ARG ATHEME_VERSION
ARG BUILD_CONTRIB_MODULES
RUN mkdir /atheme-src

# Install build-deps and runtime deps
RUN apk add --no-cache \
    build-base \
    pkgconf \
    openssl-dev \
    git

# libexecinfo is used by contrib/gen_echoserver
RUN test -z "$BUILD_CONTRIB_MODULES" || apk add --no-cache libexecinfo-dev

# Checkout from Git - we need to manually bump the libmowgli snapshot to fix compilation against musl
# This will be fixed when 7.3 releases
RUN git clone https://github.com/atheme/atheme -b v${ATHEME_VERSION} --depth=1 atheme-src --recursive
RUN cd /atheme-src/libmowgli-2 && \
    git pull origin master

# Configure and build
RUN cd /atheme-src && \
    ./configure --prefix=/atheme $(test -z "$BUILD_CONTRIB_MODULES" || echo --enable-contrib) && \
    make -j$(nproc) && make install


FROM alpine:latest
ARG ATHEME_UID
ARG BUILD_CONTRIB_MODULES

RUN apk add --no-cache openssl && (test -z "$BUILD_CONTRIB_MODULES" || apk add --no-cache libexecinfo)

COPY --from=builder /atheme/ /atheme
RUN adduser -D -h /atheme -u $ATHEME_UID atheme
RUN chown -R atheme /atheme
USER atheme

# Services config & DB
VOLUME /atheme/etc

ENTRYPOINT ["/atheme/bin/atheme-services", "-n"]
