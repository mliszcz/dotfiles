#!/usr/bin/env bash

exec sed --unbuffered -e '
  s/kitty//gI
  s/terminator//gI
  s/Alacritty//gI
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
  s/calc//gI
  s/writer//gI
  s/impress//gI
  s/thunderbird//gI
  s/file-roller//gI
  s/Chromium//gI'
