#!/bin/bash
cd "$(dirname "$0")"

# podman run --rm -v /feature:/feature -it alpine
# apk add qemu-img
# cd /feature
# qemu-img create git.iso 2G
#
# gdisk /feature/git.iso

sudo losetup -fP /feature/git.iso
# /run/media/dev/git
