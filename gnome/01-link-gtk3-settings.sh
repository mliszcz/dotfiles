#!/usr/bin/env bash

# https://developer.gnome.org/gtk3/stable/GtkSettings.html

set -v

mkdir -p ~/.config/gtk-3.0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf $DIR/resources/gtk-3.0-settings.ini ~/.config/gtk-3.0/settings.ini

set +v

