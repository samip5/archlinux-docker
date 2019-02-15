ARG ARCH=amd64
FROM lopsided/archlinux-$ARCH

WORKDIR /archlinux

RUN mkdir -p /archlinux/rootfs

COPY pacstrap-docker /archlinux/

RUN ./pacstrap-docker /archlinux/rootfs \
	bash sed gzip pacman

# Remove current pacman database, likely outdated very soon
RUN rm rootfs/var/lib/pacman/sync/*

FROM scratch
ARG ARCH=amd64

COPY --from=0 /archlinux/rootfs/ /
COPY rootfs/common/ /
COPY rootfs/$ARCH/ /

ENV LANG=en_US.UTF-8

RUN locale-gen
RUN pacman-key --init
RUN pacman-key --populate archlinux || pacman-key --populate archlinuxarm

CMD ["/usr/bin/bash"]
