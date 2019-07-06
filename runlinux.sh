#!/bin/sh

export TMP=/chroot
exec /chroot/tini /linux root=/dev/root rootflags=/chroot rootfstype=hostfs rw mem=128M udb0=alpine-root verbose eth0=slirp,,/slirp init=/init.sh
