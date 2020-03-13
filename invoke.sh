#!/usr/bin/env bash
#
#  INVOKE USING THIS SCRIPT!
#

docker run --rm -eUSER=$USER -eHOME=$HOME -v$HOME:$HOME -w $PWD @IMAGE@ "$@"
