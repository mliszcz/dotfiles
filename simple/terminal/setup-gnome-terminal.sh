#!/usr/bin/env bash

# https://wiki.gnome.org/Apps/Terminal/FAQ

set -v

PROFILE=`gsettings get org.gnome.Terminal.ProfilesList default | xargs echo`
PROFILE_PATH=/org/gnome/terminal/legacy/profiles:/:$PROFILE/

function set_key {
  gsettings set org.gnome.Terminal.Legacy.Profile:$PROFILE_PATH "$1" "$2"
}

set_key scroll-on-output 'false'
set_key scroll-on-keystroke 'true'
set_key scrollback-unlimited 'true'
set_key use-theme-colors 'false'
set_key background-color 'rgb(0,0,0)'
set_key foreground-color 'rgb(170,170,170)'
set_key bold-color-same-as-fg 'true'
set_key audible-bell 'false'

set +v
