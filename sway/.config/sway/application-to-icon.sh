#!/usr/bin/env bash

exec sed --unbuffered -e '
  s/kitty//gI
  s/terminator//gI
  s/cmus//gI
  s/ranger//gI
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
  s/Chromium//gI'
