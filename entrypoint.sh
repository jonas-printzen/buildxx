#!/usr/bin/env bash

WORKDIR=$PWD

USER=$(basename $HOME)

# We expect $HOME to be mounted
DUID=$(ls -nd $HOME|cut -d' ' -f3)
DGID=$(ls -nd $HOME|cut -d' ' -f4)

good_mount() {
  [ "$DUID" != "0" ] && [ "$DGID" != "0" ]
}

good_user() {
  [ "$EUID" == "0" ] && [ "$DUID" != "0" ] \
      && [ "$USER" != "root" ] && [ "$USER" != "" ] \
      && [ "$HOME" != "/root" ] && [ "$HOME" != "/" ] && [ "$HOME" != "" ]
}

assert_user() {
  if ! id $USER >/dev/null 2>&1; then
    groupadd -g $DGID build
    useradd -d $HOME -u $DUID -g $DGID $USER
    if ! [ -d $(dirname $HOME) ]; then
      mkdir -p $(dirname $HOME)
    fi
  fi
  return 0
}

# Detect usage case
if ! good_mount; then
  cat /srv/invoke.sh | sed "s#@IMAGE@#$DOCKER_IMAGE#g"
  exit
fi

# Detect command case
if ! assert_user; then
  echo "Failed to mirror user $USER in container!"
  exit 1
fi

echo "$@" | sudo -u $USER bash -l
