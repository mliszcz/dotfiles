#!/usr/bin/env bash

PROFILE_DIR=`firefox -CreateProfile default 2>&1 | tail -n 1 | awk '{ print $NF }' | xargs dirname`

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp $DIR/resources/* $PROFILE_DIR/
