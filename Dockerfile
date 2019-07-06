FROM ubuntu:bionic AS build
COPY uml.config /uml.config
ENV LINUX_VERSION linux-4.19.57
ENV LINUX_DOWNLOAD_URL https://cdn.kernel.org/pub/linux/kernel/v4.x/${LINUX_VERSION}.tar.xz
RUN apt-get update \
 && apt-get -y install build-essential flex bison xz-utils wget ca-certificates bc linux-headers-4.15.0-47-generic \
 && wget ${LINUX_DOWNLOAD_URL} \
 && tar xJf ${LINUX_VERSION}.tar.xz \
 && rm ${LINUX_VERSION}.tar.xz \
 && cd ${LINUX_VERSION} \
 && cp /uml.config .config \
 && make ARCH=um -j10 \
 && mv ./linux / \
 && cd .. \
 && rm -rf ${LINUX_VERSION}

FROM xena/alpine

COPY --from=build /linux /linux
ADD https://xena.greedo.xeserv.us/files/slirp /slirp

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /chroot/tini
RUN chmod +x /chroot/tini

# Set up chroot
RUN cd /chroot \
 && wget -O - http://dl-cdn.alpinelinux.org/alpine/v3.10/releases/x86_64/alpine-minirootfs-3.10.0-x86_64.tar.gz | tar xz \
 && chmod +x /linux \
 && chmod +x /slirp
COPY init.sh /chroot/init.sh
COPY resolv.conf /chroot/etc/resolv.conf

COPY runlinux.sh /runlinux.sh
CMD /runlinux.sh
