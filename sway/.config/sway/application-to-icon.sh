#!/usr/bin/env bash

exec sed --unbuffered -e '
  s/kitty//gI
  s/terminator//gI
  s/Alacritty//gI
  s/foot//gI
  s/cmus//gI
  s/ranger//gI
  s/pcmanfm//gI
  s/org.gnome.nautilus//gI
  s/Firefox//gI
  s/mpv//gI
  s/imv//gI
  s/zathura//gI
  s/deluge//gI
  s/gimp//gI
  s/swappy//gI
  s/libreoffice-calc//gI
  s/libreoffice-writer//gI
  s/libreoffice-impress//gI
  s/gedit//gI
  s/thunderbird//gI
  s/file-roller//gI
  s/org.qutebrowser.qutebrowser//gI
  s/luakit//gI
  s/Chromium//gI'
