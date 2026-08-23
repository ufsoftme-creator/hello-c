FROM alpine:3.22 AS build

ARG VERSION=docker
WORKDIR /src

RUN apk add --no-cache build-base
COPY hello.c Makefile ./
RUN make clean && make VERSION="$VERSION" LDFLAGS=-static

FROM alpine:3.22

COPY --from=build /src/hello /usr/local/bin/hello
ENTRYPOINT ["/usr/local/bin/hello"]