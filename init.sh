#!/bin/sh

mount -t proc proc proc/
mount -t sysfs sys sys/
ip link set eth0 up
ip address add 10.0.2.15/24 dev eth0
ip route add default via 10.0.2.2

uname -av
echo "networking set up"

exec /tini /bin/ash -- -i
