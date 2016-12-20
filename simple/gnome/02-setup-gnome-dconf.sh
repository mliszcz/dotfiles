#!/usr/bin/env bash

# https://wiki.gnome.org/Apps/Terminal/FAQ

set -v

PROFILE=`gsettings get org.gnome.Terminal.ProfilesList default | xargs echo`
PROFILE_PATH=/org/gnome/terminal/legacy/profiles:/:$PROFILE/

ENABLED_EXTENSIONS="[
  'alternate-tab@gnome-shell-extensions.gcampax.github.com',
  'user-theme@gnome-shell-extensions.gcampax.github.com'
]"

FAVORITE_APPS="[
  'firefox.desktop',
  'nautilus.desktop',
  'gnome-terminal.desktop',
  'deadbeef.desktop'
]"

function set_key {
  gsettings set $1 $2 "$3"
}

set_key org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
set_key org.gnome.shell.overrides        dynamic-workspaces    'false'
set_key org.gnome.desktop.wm.preferences num-workspaces        '1'
set_key org.gnome.nautilus.window-state  maximized             'true'
set_key org.gnome.desktop.interface      clock-show-seconds    'true'
set_key org.gnome.desktop.interface      clock-show-date       'true'
set_key org.gnome.desktop.interface      monospace-font-name   'Hack 13'
set_key org.gnome.nautilus.preferences   default-sort-order    'mtime'
set_key org.gnome.nautilus.preferences   default-folder-viewer 'list-view'
set_key org.gnome.nautilus.window-state  maximized             'true'
set_key org.gnome.desktop.calendar       show-weekdate         'true'
set_key org.gnome.shell                  enabled-extensions    "$ENABLED_EXTENSIONS"
set_key org.gnome.shell                  favorite-apps         "$FAVORITE_APPS"

set +v
