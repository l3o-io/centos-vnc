FROM quay.io/l3o/centos-8:systemd
LABEL maintainer="Christian Felder"
LABEL RUN="podman run --rm -P --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d IMAGE"

WORKDIR /root

RUN dnf install -y epel-release && \
  dnf update -y && dnf install -y \
  tigervnc-server \
  && \
  dnf group install -y xfce-desktop \
  && \
  dnf clean all -y

COPY entrypoint.sh /
COPY startxfce4.bash /usr/bin/
COPY xfce4-screensaver.xml /usr/share/backgrounds/
COPY xfce4-desktop.xml /usr/share/backgrounds/
EXPOSE 5901/tcp

VOLUME ["/config"]

ENV USER_ID=10000
ENV USER="container"
ENV VNCPASSWD="pod.VNC"
ENV VNCRESOLUTION="1280x720"
ENV BACKGROUND="/usr/share/backgrounds/images/default.png"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/sbin/init"]
