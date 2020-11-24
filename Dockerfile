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

COPY startxfce4.bash /usr/bin/
RUN sed '/^#/! s/<USER>/root/g' /usr/lib/systemd/system/vncserver\@.service \
  > /etc/systemd/system/vncserver\@.service \
  && \
  sed -i 's/gnome-session/startxfce4.bash/' /etc/X11/xinit/Xclients \
  && \
  systemctl enable vncserver@:1 && \
  mkdir -m 700 $HOME/.vnc \
  && \
  echo "pod.VNC" | vncpasswd -f > $HOME/.vnc/passwd \
  && \
  chmod 600 $HOME/.vnc/passwd
EXPOSE 5901/tcp
