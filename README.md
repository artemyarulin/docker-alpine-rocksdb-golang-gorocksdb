# docker-alpine-rocksdb-golang-gorocksdb

Example how to build Docker Alpine image with RocksDB, Golang and gorocksdb

Just check [Dockerfile](Dockerfile). Build is based on https://pkgs.alpinelinux.org/package/edge/testing/x86_64/rocksdb and uses patch from there.

Much easier way could be completely rely on Alpine `rocksdb` package but I wasn't able to compile `gorocksdb` with that. I've used following Dockerfile

```Dockerfile
FROM golang:1.13.3-alpine
WORKDIR /app
RUN apk add rocksdb-dev --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
COPY ./go.* ./
RUN go mod download && go mod verify
COPY ./*.go ./
RUN go test -v && go build -o /app
ENTRYPOINT ["/app"]

```
