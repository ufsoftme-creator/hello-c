FROM alpine:3.22 AS build

ARG VERSION
WORKDIR /src

RUN apk add --no-cache build-base
COPY hello.c Makefile ./
RUN if [ -n "$VERSION" ]; then \
		make clean && make VERSION="$VERSION" LDFLAGS=-static; \
	else \
		make clean && make LDFLAGS=-static; \
	fi

FROM alpine:3.22

COPY --from=build /src/hello /usr/local/bin/hello
ENTRYPOINT ["/usr/local/bin/hello"]