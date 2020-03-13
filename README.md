# The builder

## Outline

This is everything needed to build software with a docker image. 
The image will be executed instead of running __make__ when developing. 
By putting the toolchain in the image you don't need it installed locally.
You also get perfect history and control of the toolchain.
As an added value, exactly the same image can be used in build-automation.

 ><big>__Note!__</big>
 >This image exposes your entire $HOME directory to make sure any
 >caching directories and personal configuration (.m2,.netrc) can be used!
 >If this violates your sense of security, don't use this image!

Firstly, when invoked without the proper arguments, it provides a shell-script
to use for proper invocation.

```sh
$> docker run --rm pzen/buildxx
#!/usr/bin/env bash
#
#  INVOKE USING THIS SCRIPT!

docker run --rm -eUSER=$USER -eHOME=$HOME\
                -v$HOME:$HOME -w $PWD @IMAGE@ <your command>
```

The easiest way to use this is to put it in a file.

```sh
$> docker run --rm pzen/buildxx >build
$> chmod +x build
$> ./build make
make: *** No targets specified and no makefile found.  Stop.
```

To add your own system-level dependencies just create a new image.

```Dockerfile
FROM pzen/buildxx

ARG THIS_IMAGE=<image-name>
ENV BUILD_IMAGE=${THIS_IMAGE}

RUN apt-get update && apt-get install -y clang boost ... \
 && apt-get clean && rm -rf /var/lib/apt/lists/*
 
```
