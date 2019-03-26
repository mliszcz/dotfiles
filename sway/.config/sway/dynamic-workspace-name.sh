#!/usr/bin/env bash

stdbuf -o0 swaymsg -m --raw -t subscribe '["window"]' \
  | jq --unbuffered --raw-output '@sh "\(.container.id) \(.container.app_id // .container.window_properties.class)"' \
  | xargs -n 2 -- printf "'.nodes[].nodes[] | select(.. | objects | select(.id == %s)) | @sh \"\(.num) \(.num) %s\"'\n" \
  | xargs -n 1 -I% sh -c "swaymsg -t get_tree | jq --unbuffered --raw-output '%'" \
  | sed --unbuffered -e '
    s/kitty//g
    s/cmus//g
    s/ranger//g
    s/Firefox//g
    s/mpv//g
    s/imv//g
    s/zathura//g
    s/deluge//g
    s/gimp//g
    s/calc//g
    s/writer//g
    s/impress//g
    s/thunderbird//g
    s/Chromium//g' \
  | xargs -n 3 -- printf "\"rename workspace number %s to '%s: %s'\"\n" \
  | xargs -n 1 -I% sh -c "sleep 1.0s; echo '\"%\"'" \
  | tee /dev/stderr \
  | xargs -n 1 -- swaymsg
