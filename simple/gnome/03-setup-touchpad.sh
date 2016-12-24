#!/usr/bin/env bash

# This is only for wayland-based installations. Xorg uses xf86-input-libinput
# and confiruation from /etc/X11/xorg.conf.d/
# https://wayland.freedesktop.org/libinput/doc/latest/faq.html#faq_config_options
# https://wiki.archlinux.org/index.php/Libinput#Common_options

set -v

function set_key {
  gsettings set org.gnome.desktop.peripherals.touchpad $1 "$2"
}

set_key send-events                  'enabled'
set_key tap-to-click                 'true'
set_key natural-scroll               'false'
set_key edge-scrolling-enabled       'false'
set_key two-finger-scrolling-enabled 'true'

set +v
