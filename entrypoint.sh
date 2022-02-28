#!/bin/sh
set -eu

USER_ID=${USER_ID:=10000}
USER=${USER:="root"}
VNCPASSWD=${VNCPASSWD:="pod.VNC"}
VNCRESOLUTION=${VNCRESOLUTION:="1280x720"}
DESKTOP=${DESKTOP:="/config/desktop"}
STARTXFCE4=${STARTXFCE4:="startxfce4.bash"}

if [ -z "$BACKGROUND" ] || [ ! -f "$BACKGROUND" ]; then
  BACKGROUND="/usr/share/backgrounds/images/default.png"
fi

# dynamically create user
if [ "$USER" != "root" ]; then
  HOME=/home/$USER
  useradd -u $USER_ID -g 0 -d $HOME $USER
fi

echo ":1=$USER" >> /etc/tigervnc/vncserver.users
sed -i 's/^\(Exec=\)startxfce4$/\1'"$STARTXFCE4"'/' \
  /usr/share/xsessions/xfce.desktop
systemctl unmask systemd-logind.service
systemctl enable vncserver@:1
mkdir -m 700 $HOME/.vnc
echo "$VNCPASSWD" | vncpasswd -f > $HOME/.vnc/passwd
echo "geometry=$VNCRESOLUTION" > $HOME/.vnc/config
echo "session=xfce" >> $HOME/.vnc/config
chmod 600 $HOME/.vnc/passwd
chown -R $USER:root $HOME/.vnc/

sed -i 's|\(.*\){{ background }}\(.*\)|\1'"$BACKGROUND"'\2|g' \
  /usr/share/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

if [ -d "$DESKTOP" ]; then
  [ -d $HOME/Desktop ] || mkdir $HOME/Desktop && chown $USER:root $HOME/Desktop
  cp -a $DESKTOP/*.desktop $HOME/Desktop/ &2>/dev/null
fi

exec "$@"
