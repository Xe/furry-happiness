#!/bin/sh

mount -t proc proc proc/
mount -t sysfs sys sys/
ifconfig eth0 10.0.2.14 netmask 255.255.255.240 broadcast 10.0.2.15
route add default gw 10.0.2.2

reset
uname -av
echo "networking set up"

exec /tini /bin/sh
