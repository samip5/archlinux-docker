# Basic Arch Linux Docker images [![Build Status](https://travis-ci.com/samip5/archlinux-docker.svg?branch=master)](https://travis-ci.com/samip537/archlinux-docker)

Docker images for Arch Linux on x86_64, AArch32 (ARMv6-A, ARMv7-A) and AArch64 (ARMv8-A). Built using native pacman and Docker multi-stage builds. Builds weekly by Travis CI on publicly visible infrastructure using QEMU emulation to support ARM.

## Running the images

The images are on [Docker Hub](https://hub.docker.com/u/samip537/). Use the convenient `docker run`:

    docker run --rm -ti samip537/archlinux

Instead of using the multi-arch container above, you can also get the architecture specific image directly:

    docker run --rm -ti samip537/archlinux:arm32v7

## Tags

|  Tag   |   Update   |    Type    |              Description               |
|:------:|:----------:|:----------:|:---------------------------------------|
| amd64 | **daily**  | minimal    | Minimal Arch Linux with pacman support |
| arm32v6 | **daily**  | minimal    | Minimal Arch Linux with pacman support |
| arm32v7 | **daily**  | minimal    | Minimal Arch Linux with pacman support |
| arm64v8 | **daily**  | minimal    | Minimal Arch Linux with pacman support |
| devel  | **daily**  | base-devel | Arch Linux with base-devel installed   |
| yay  | **daily**  | base-devel + yay + sudo | Arch Linux with base-devel, sudo and yay aur helper installed.   Contains a default user called user too with sudo access without password   |

Latest is with the architecture, and if not specified, it will download the correct minimal for the architecture you're running Docker from.

To get specifc architecture images, you need to use the following format samip537/archlinux:$ARCH-$TAG.

Eg:
```
docker run --rm -ti samip537/archlinux:arm32v7-yay
```

### Layer structure

The image is generated from a freshly built pacman rootfs. Pacman has configured
to delete man pages and clean the package cache after installation to keep
images small.

## Issues and improvements

If you want to contribute, get to the [issues-section of this repository](https://github.com/samip5/archlinux-docker/issues).

## Common hurdles

### Setting the timezone

Simply add the `TZ` environment-variable and define it with a valid timezone-value.

```
docker run -e TZ=Europe/Helsinki samip537/archlinux
```

## Building it yourself

### Prerequisites

- Docker with experimental mode on (required for squash)
- sudo or root is neccessary to setup binfmt for Qemu user mode emulation

### Building

- Prepare binfmt use with Qemu user mode using `sudo ./prepare-qemu`
- Run `BUILD_ARCH=<arch> ./build` to build
  - Use `BUILD_ARCH=amd64` for x86_64
  - Use `BUILD_ARCH=arm32v5` for ARMv5 Aarch32
  - Use `BUILD_ARCH=arm32v6` for ARMv6 Aarch32
  - Use `BUILD_ARCH=arm32v7` for ARMv7 Aarch32
  - Use `BUILD_ARCH=arm64v8` for ARMv8 Aarch64

If you want to push the images, run `./push`. *But be aware you have no push access to the repos! Edit the scripts to push to custom Docker Hub locations!*

### Building from scratch

Since the image depends on itself, the question which arises is how this all
started. The initial containers have been created using the tarballs provided by
the Arch Linux ARM project. 

ARMv6 is based off the image for Raspberry Pi 1, which may or may not work on other hardware.

I used the following steps to bootstrap for each
architecture:

```
sudo tar xvzf ArchLinuxARM-armv7-latest.tar.gz -C tmp-arch
sudo tar cf ArchLinuxARM-armv7-latest.tar -C tmp-arch/ .
docker import ArchLinuxARM-armv7-latest.tar samip537/archlinux:arm32v7
```

## Credits

Ideas have been taken from already existing Docker files for Arch Linux.
However, this repository takes a slightly different approach to create images.

- https://github.com/lopsided98/archlinux-docker
  - Missing the actual way to start the images from scratch.
  - Travis build not building, and thus not updating images. (originially)
- https://github.com/agners/archlinux-docker
  - Limited architectures
  - Duplication of Dockerfiles
  - Only built weekly
  - No image with base-devel preinstalled
- https://github.com/archlinux/archlinux-docker
  - Focus on Arch Linux for x86
  - Uses docker run in priviledged mode to build images
- https://github.com/lopsided98/archlinux
  - Uses prebuilt tarballs which contain packages not required in containers
