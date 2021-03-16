FROM alpine:latest
ARG TRAEFIK_VERSION="2.4.7"
RUN apk --no-cache add ca-certificates tzdata && \
    set -ex && \
    Arch="$(apk --print-arch)" && \
    case "$Arch" in \
      armhf)   arch='armv6' ;; \
      armv7)   arch='armv7' ;; \
      aarch64) arch='arm64' ;; \
      x86_64)  arch='amd64' ;; \
      *)       echo >&2 "unsupported architecture: $Arch"; exit 1 ;; \
    esac && \
    wget --quiet -O /tmp/traefik.tar.gz "https://github.com/traefik/traefik/releases/download/${TRAEFIK_VERSION}/traefik_${TRAEFIK_VERSION}_linux_$arch.tar.gz" && \
    tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik && \
    rm -f /tmp/traefik.tar.gz && \
    chmod +x /usr/local/bin/traefik

EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["traefik"]
