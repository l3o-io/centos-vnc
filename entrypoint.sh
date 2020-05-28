#!/bin/sh
set -eu

USER=${USER:="root"}
VNCPASSWD=${VNCPASSWD:="pod.VNC"}

sed '/^#/! s/<USER>/'"$USER"'/g' /usr/lib/systemd/system/vncserver\@.service \
  > /etc/systemd/system/vncserver\@.service
sed -i 's/gnome-session/startxfce4.bash/' /etc/X11/xinit/Xclients
systemctl enable vncserver@:1
mkdir -m 700 $HOME/.vnc
echo "$VNCPASSWD" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

exec "$@"
