ARG DEB_VERSION=stable-slim
FROM debian:${DEB_VERSION}

LABEL maintainer="Will Fantom <w.fantom@lancs.ac.uk>"

## Install Base Dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -yq \
    git \
    net-tools \
    sudo

## Install Mininet via Script
COPY . /root/mininet
RUN chmod +x /root/mininet/util/docker/entrypoint.sh
ARG SCRIPT_FLAGS=-fnv
RUN sh -c "/root/mininet/util/install.sh ${SCRIPT_FLAGS}"

## Install Extra Packages
ARG EXTRA_PACKAGES=""
RUN apt-get install -yq \
    arping \
    hping3 \
    iputils-ping \
    traceroute \
    ${EXTRA_PACKAGES}

## Clean Up
RUN apt-get clean

## Setup for Entry
ENV MN_FLAGS=""
ENV PY_FILE=""
ENV TOPO_DIR=/topos
WORKDIR ${TOPO_DIR}

ENTRYPOINT [ "sh", "-c", "/root/mininet/util/docker/entrypoint.sh" ]
