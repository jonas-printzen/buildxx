# The builder

## Outline

This is an attempt to collect everything I need to build software
in a docker image. The image will be executed instead of running __make__
when developing. As an added value exactly the same image will be used in build-automations.

Firstly, when invoked without proper arguments, it provides a shell-script
to use for proper invocation.

```sh
$> docker run --rm pzen/buildxx

#!/usr/bin/env bash
#
#  INVOKE USING THIS SCRIPT!

docker container run --rm -v$HOME:/srv/work \
                     -eUSER=$USER -eUID=$UID \
                     -eHOME=$HOME -eBUILD_DIR=$PWD\
                     buildxx "$@"
```

The easiest way to use this is to put it in a script.

```sh
$> docker run --rm buildxx >build
$> chmod +x build
$> ./build make
make: Nothing to be done for 'compile'.
```

To add your own system-level dependencies just create a new image.

```Dockerfile
FROM pzen/buildxx

ARG THIS_IMAGE=<image-name>

RUN apt-get update && apt-get install -y clang boost ... \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

```
