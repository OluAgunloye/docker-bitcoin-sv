FROM alpine:latest AS builder

RUN apk add build-base automake autoconf libtool pkgconfig boost-dev \
  openssl-dev libevent-dev zeromq-dev

RUN wget https://github.com/bitcoin-sv/bitcoin-sv/archive/v0.2.1.tar.gz
RUN tar -xf v0.2.1.tar.gz

WORKDIR bitcoin-sv-0.2.1
COPY include-fix.patch .
RUN patch -Np1 < include-fix.patch

RUN ./autogen.sh && \
  ./configure \
    --prefix=/install \
    --disable-wallet \
    --without-miniupnpc \
    --without-seeder \
    --without-utils \
    --enable-zmq \
    --disable-tests \
    --disable-bench \
    --disable-static \
    --disable-shared \
    --enable-prod-build \
  && make -j$(nproc --all) \
  && make install \
  && strip /install/bin/bitcoind

FROM alpine:latest

RUN apk add --no-cache boost-chrono boost-program_options boost-thread boost-filesystem zeromq libevent

COPY --from=builder /install /usr/local

VOLUME /data
EXPOSE 8332 8333 28332

CMD ["bitcoind", "-printtoconsole", "-conf=/bsv.conf", "-datadir=/data"]
