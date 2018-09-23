#!/usr/bin/env bash
#
#  INVOKE USING THIS SCRIPT!

docker container run --rm -v$HOME:/srv/work \
                     -eUSER=$USER -eUID=$UID \
                     -eHOME=$HOME -eBUILD_DIR=$PWD\
                     @IMAGE@ "$@"
