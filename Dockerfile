# busybox contains wget that can be used todownload files and we could reduce the dependencies to one image,
# but wget does not support tls verification (https://github.com/docker-library/busybox/issues/80)
# and wget fails on arch arm64 (https://github.com/docker-library/busybox/issues/162#issuecomment-1773905855)

FROM --platform=$BUILDPLATFORM docker.io/curlimages/curl:8.23.0@sha256:6b46ee7c652d53ef17ddf1428b1a365a66d913d21c54df42e2e46d5bd321bb46 AS build
SHELL ["/bin/ash", "-u", "-e", "-o", "pipefail", "-c"]
ARG TARGETARCH
RUN [ "$TARGETARCH" = amd64 ] && export ARCH=x86_64; \
	[ "$TARGETARCH" = arm64 ] && export ARCH=aarch64; \
	[ -z "${ARCH:-}" ] && echo "Unknown arch: $TARGETARCH" && exit 1; \
	curl --fail --silent --location --remote-name-all "https://github.com/casey/just/releases/download/1.59.0/{just-1.59.0-$ARCH-unknown-linux-musl.tar.gz,SHA256SUMS}" && \
	grep "just-1.59.0-$ARCH-unknown-linux-musl.tar.gz" SHA256SUMS | sha256sum -c -s && \
	tar --gz --extract --file="just-1.59.0-$ARCH-unknown-linux-musl.tar.gz" just --directory=/tmp && \
	rm -rf "just-1.59.0-$ARCH-unknown-linux-musl.tar.gz" SHA256SUMS

FROM docker.io/library/busybox:1.38.0-uclibc@sha256:b699b0c739b2d039afd8e2488a3ccfc0b9a86301d87633448d4a93c57bee8c76
COPY --chmod=555 --chown=0:0 --from=build /tmp/just /usr/bin/just
COPY --chmod=555 --chown=0:0 entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
USER 1000:1000
