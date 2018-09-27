
FROM ubuntu:bionic

LABEL maintainer="PZEN <jonas.printzen@gmail.com>"

ARG THIS_IMAGE=pzen/buildxx
ENV BUILD_IMAGE=${THIS_IMAGE}

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get upgrade  -y --no-install-recommends \
 && apt-get install -y --no-install-recommends sudo make \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


ENV BUILD_BIN=/srv
ENV BUILD_WORK=/srv/work

WORKDIR ${BUILD_WORK}
VOLUME ${BUILD_WORK}

COPY entrypoint.sh ${BUILD_BIN}/entrypoint.sh
COPY invoke.sh ${BUILD_BIN}/invoke.sh

ENTRYPOINT ["/srv/entrypoint.sh"]
