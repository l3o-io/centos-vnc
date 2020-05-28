#!/bin/sh
set -eu

USER_ID=${USER_ID:=10000}
USER=${USER:="root"}
VNCPASSWD=${VNCPASSWD:="pod.VNC"}

# dynamically create user
if [ "$USER" != "root" ]; then
  HOME=/home/$USER
  useradd -u $USER_ID -g 0 -d $HOME $USER
fi

sed '/^#/! s/<USER>/'"$USER"'/g' /usr/lib/systemd/system/vncserver\@.service \
  > /etc/systemd/system/vncserver\@.service
sed -i 's/gnome-session/startxfce4.bash/' /etc/X11/xinit/Xclients
systemctl unmask systemd-logind.service
systemctl enable vncserver@:1
mkdir -m 700 $HOME/.vnc
echo "$VNCPASSWD" | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd
chown -R $USER:root $HOME/.vnc/

exec "$@"
