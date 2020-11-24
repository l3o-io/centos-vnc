#!/bin/bash
set -e

STARTXFCE4="$(type -p startxfce4)"

# disable screen savers and power management
xset -dpms
xset s noblank
xset s off

# start window manager
[ -n "$STARTXFCE4" ] && exec "$STARTXFCE4"
