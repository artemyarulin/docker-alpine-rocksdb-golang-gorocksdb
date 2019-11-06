FROM golang:1.13.3-alpine
WORKDIR /app
ENV ROCKSDB_VERSION='5.17.2'
RUN apk add -U build-base linux-headers cmake bash zlib-dev bzip2-dev snappy-dev lz4-dev librdkafka-dev zstd-dev curl perl && \
    wget https://github.com/facebook/rocksdb/archive/v${ROCKSDB_VERSION}.zip -O rocksdb-${ROCKSDB_VERSION}.zip && \
    unzip rocksdb-${ROCKSDB_VERSION}.zip -d . && cd rocksdb-${ROCKSDB_VERSION} && \
    curl https://git.alpinelinux.org/aports/plain/testing/rocksdb/10-support-busybox-install.patch | patch && \
    make -j8 shared_lib && make -j8 install-shared
COPY ./go.* ./
RUN CGO_CFLAGS="-I /app/rocksdb-$ROCKSDB_VERSION/include" \
    CGO_LDFLAGS="-L /app/rocksdb-$ROCKSDB_VERSION -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4" \
    go mod download && go mod verify
COPY ./*.go ./
RUN go test -v && go build -o /app
ENTRYPOINT ["/app"]
