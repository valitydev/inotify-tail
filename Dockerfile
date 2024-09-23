# syntax=docker/dockerfile:1.2

FROM --platform=${TARGETPLATFORM} alpine:latest as base

RUN apk add --no-cache bash coreutils

COPY monitor.sh /usr/local/bin/monitor

RUN chmod +x /usr/local/bin/monitor

CMD ["/usr/local/bin/monitor"]
