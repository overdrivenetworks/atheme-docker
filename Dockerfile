FROM alpine:3.11

ARG ATHEME_VERSION=7.2.10-r2
ARG CONFIGURE_ARGS=--enable-contrib
ARG ATHEME_UID=10000

RUN adduser -D -h /atheme -u $ATHEME_UID atheme
RUN mkdir /atheme-src

# Install build-deps
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    pkgconf \
    openssl-dev \
    # Used by contrib/gen_echoserver.so
    libexecinfo-dev \
    git
# Runtime deps
RUN apk add openssl libexecinfo

# Checkout from Git - we need to manually bump the libmowgli snapshot to fix compilation against musl
# This will be fixed when 7.3 releases
RUN git clone https://github.com/atheme/atheme -b v${ATHEME_VERSION} atheme-src --recursive
RUN cd /atheme-src/libmowgli-2 && git pull origin master

# Configure and build
RUN cd /atheme-src && \
    ./configure --prefix=/atheme $CONFIGURE_ARGS
RUN cd /atheme-src && \
    make -j$(nproc) && make install

# Remove source dir and build deps
RUN rm -rf /atheme-src && apk del .build-deps

RUN chown -R atheme /atheme
USER atheme
# Services config
VOLUME /atheme/etc
# Services DB
VOLUME /atheme/var

ENTRYPOINT ["/atheme/bin/atheme-services", "-n"]
