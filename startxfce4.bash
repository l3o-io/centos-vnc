#!/bin/bash
set -e

STARTXFCE4="$(type -p startxfce4)"

# disable screen savers and power management
xset -dpms
xset s noblank
xset s off

# set wallpaper + ensure screensaver is switched off for this user
if [ ! -d $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ ]; then
  mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
fi
cp -af /usr/share/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml \
  /usr/share/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml \
  $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/

# mark shortcuts on the desktop as trusted to execute
set +e
DESKTOPFILES="$(ls ~/Desktop/*.desktop)" 2>/dev/null
set -e
if [ -n "$DESKTOPFILES" ]; then
  for f in $DESKTOPFILES; do
    gio set -t string "$f" metadata::xfce-exe-checksum "$(sha256sum "$f" | cut -d" " -f1)"
  done
fi

# start window manager
[ -n "$STARTXFCE4" ] && exec "$STARTXFCE4"
