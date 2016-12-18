#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p ~/.config/deadbeef

# ln -sf $DIR/config ~/.config/deadbeef/config
cp $DIR/config ~/.config/deadbeef/config
