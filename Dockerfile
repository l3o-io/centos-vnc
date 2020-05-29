FROM docker.io/adevur/centos-8:systemd
LABEL maintainer="Christian Felder"

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
EXPOSE 5901/tcp

ENV USER_ID=10000
ENV USER="container"
ENV VNCPASSWD="pod.VNC"
ENV VNCRESOLUTION="1280x720"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/sbin/init"]
