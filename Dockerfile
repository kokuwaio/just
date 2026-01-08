# busybox contains wget that can be used todownload files and we could reduce the dependencies to one image,
# but wget does not support tls verification (https://github.com/docker-library/busybox/issues/80)
# and wget fails on arch arm64 (https://github.com/docker-library/busybox/issues/162#issuecomment-1773905855)

FROM docker.io/curlimages/curl:8.18.0@sha256:d94d07ba9e7d6de898b6d96c1a072f6f8266c687af78a74f380087a0addf5d17 AS build
SHELL ["/bin/ash", "-u", "-e", "-o", "pipefail", "-c"]
ARG TARGETARCH
RUN [ "$TARGETARCH" = amd64 ] && export ARCH=x86_64; \
	[ "$TARGETARCH" = arm64 ] && export ARCH=aarch64; \
	[ -z "${ARCH:-}" ] && echo "Unknown arch: $TARGETARCH" && exit 1; \
	curl --fail --silent --location --remote-name-all "https://github.com/casey/just/releases/download/1.46.0/{just-1.46.0-$ARCH-unknown-linux-musl.tar.gz,SHA256SUMS}" && \
	grep "just-1.46.0-$ARCH-unknown-linux-musl.tar.gz" SHA256SUMS | sha256sum -c -s && \
	tar --gz --extract --file="just-1.46.0-$ARCH-unknown-linux-musl.tar.gz" just --directory=/tmp && \
	rm -rf "just-1.46.0-$ARCH-unknown-linux-musl.tar.gz" SHA256SUMS && \
	/tmp/just --version

FROM docker.io/library/busybox:1.37.0-uclibc@sha256:473b2c7d4a96550a69ca5ba1701615df096ccc6e7d8fc62aecaf4bdfb99b9671
COPY --chmod=555 --chown=0:0 --from=build /tmp/just /usr/bin/just
COPY --chmod=555 --chown=0:0 entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
USER 1000:1000
