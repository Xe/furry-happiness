# furry-happiness

A proof of concept [user mode linux](https://en.wikipedia.org/wiki/User-mode_Linux)
Docker image. This builds a simply configured kernel and sets up an [Alpine Linux](https://alpinelinux.org)
userland for it. It has fully working networking via slirp.

This runs an entire Linux kernel as a userspace process inside a docker container.
Anything you can do as root in a linux kernel, you can do inside this user mode
Linux process. The root inside this user mode Linux kernel has significanly more
power than root outside of the kernel, but it cannot affect the host kernel.

To build:

```
docker build -t xena/docker-uml .
```

To run:

```
docker run --rm -it xena/docker-uml
```
