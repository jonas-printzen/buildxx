#!/usr/bin/env bash

# Get ownership on mounted(?) directory
DUID=$(ls -nd|cut -d' ' -f3)
DGID=$(ls -nd|cut -d' ' -f4)

good_mount() {
  [ "$DUID" != "0" ] && [ "$DGID" != "0" ] && \
  [ "${BUILD_DIR##$HOME}" != $BUILD_DIR ]
}

good_user() {
  return [ "$EUID" == "0" ] && [ "$UID" != "0" ] \
      && [ "$USER" != "root" ] && [ "$USER" != "" ] \
      && [ "$HOME" != "/root" ] && [ "$HOME" != "/" ] && [ "$HOME" != "" ] \
      && [ "$DUID" == "$UID" ]
}

assert_user() {
  if ! id $USER >/dev/null 2>&1; then
    groupadd -g $DGID build
    useradd -d $HOME -u $UID -g $DGID $USER
    if ! [ -d $(dirname $HOME) ]; then
      mkdir -p $(dirname $HOME)
    fi
    ln -s /srv/work $HOME
  fi
  return 0
}

# Detect usage case
if ! good_mount; then
  cat /srv/invoke.sh | sed "s#@IMAGE@#$BUILD_IMAGE#g"
  exit
fi

# Detect command case
if assert_user; then
  cd $BUILD_DIR
  sudo -u $USER $@
fi
