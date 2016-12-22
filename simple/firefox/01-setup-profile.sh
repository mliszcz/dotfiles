#!/usr/bin/env bash

# http://kb.mozillazine.org/User.js_file

set -v

PROFILE_DIR=`firefox -CreateProfile default 2>&1 | tail -n 1 | awk '{ print $NF }' | xargs dirname`

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf $DIR/resources/prefs.js $PROFILE_DIR/user.js

set +v
