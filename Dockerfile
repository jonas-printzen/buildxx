
FROM ubuntu:bionic

LABEL maintainer="PZEN <jonas.printzen@gmail.com>"

ARG THIS_IMAGE=pzen/buildxx
ENV DOCKER_IMAGE=${THIS_IMAGE}

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get upgrade  -y --no-install-recommends \
 && apt-get install -y --no-install-recommends sudo \
    build-essential make cmake
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENV BUILD_BIN=/srv

COPY *.sh ${BUILD_BIN}/

ENTRYPOINT ["/srv/entrypoint.sh"]
