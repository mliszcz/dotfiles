#!/usr/bin/env bash

# https://wiki.archlinux.org/title/Screen_capture#Wayland
# https://github.com/swaywm/sway/blob/master/contrib/grimshot
exec swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'
