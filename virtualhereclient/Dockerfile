#ARG BUILD_FROM
#FROM $BUILD_FROM
ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.4
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Install minimal runtime dependencies
RUN apk add --no-cache \
    kmod \
    ca-certificates \
    curl

# Prepare VirtualHere client directory
ENV HOME=/vhclient
WORKDIR /vhclient

# Download the VirtualHere client for the current architecture
ARG BUILD_ARCH
RUN set -eux; \
    case "$BUILD_ARCH" in \
      aarch64) BIN=vhclientarm64 ;; \
      armhf)   BIN=vhclientarmhf ;; \
      amd64)   BIN=vhclientx86_64 ;; \
      i386)    BIN=vhclienti386 ;; \
      *) echo "Unsupported BUILD_ARCH: $BUILD_ARCH" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://www.virtualhere.com/sites/default/files/usbclient/${BIN}" -o /vhclient/vhclient; \
    chmod a+x /vhclient/vhclient

# Copy root filesystem containing s6 services and init scripts
COPY rootfs /

# Ensure service and init scripts are executable
RUN chmod -R a+x /etc/cont-init.d || true \
 && find /etc/services.d -type f -name run -exec chmod a+x {} + \
 && find /etc/services.d -type f -name finish -exec chmod a+x {} + || true

# Rely on base image's s6-overlay init; no explicit CMD here
