FROM ubuntu:focal AS build
COPY uml.config /uml.config

ENV LINUX_VERSION linux-5.10.47
ENV LINUX_DOWNLOAD_URL https://cdn.kernel.org/pub/linux/kernel/v5.x/${LINUX_VERSION}.tar.xz

RUN apt-get update \
 && apt-get -y install build-essential flex bison xz-utils wget ca-certificates bc \
 && wget ${LINUX_DOWNLOAD_URL} \
 && tar xJf ${LINUX_VERSION}.tar.xz \
 && rm ${LINUX_VERSION}.tar.xz \
 && cd ${LINUX_VERSION} \
 && cp /uml.config .config \
 && make ARCH=um olddefconfig \
 && make ARCH=um -j17 \
 && mv ./linux / \
 && cd .. \
 && rm -rf ${LINUX_VERSION}

FROM xena/alpine

ADD https://xena.greedo.xeserv.us/files/slirp /slirp

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /chroot/tini

# Set up chroot
RUN wget -O - http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-minirootfs-3.12.7-x86_64.tar.gz | tar xz -C /chroot

COPY --from=build /linux /linux
COPY init.sh /chroot/init.sh
COPY resolv.conf /chroot/etc/resolv.conf
RUN chmod +x /linux /slirp /chroot/tini

COPY runlinux.sh /runlinux.sh
CMD /runlinux.sh
