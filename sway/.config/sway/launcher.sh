#!/usr/bin/env bash

find \
  /usr/share/applications \
  /usr/local/share/applications \
  ~/.local/share/applications/ \
  /usr/lib/libreoffice/share/xdg/ \
  -mindepth 1 \
  -maxdepth 1 \
  -type f \
  -name "*.desktop" 2>/dev/null \
    | xargs grep -EL "Terminal=true|NoDisplay=true" \
    | xargs grep -h "^Exec=" \
    | sed -e "s/^Exec=//g;s/ %[fFuUdDnNickvm]//g" \
    | { cat; \
        echo "terminator -e cmus"; \
        echo "terminator -e ranger"; \
      } \
    | sort -u \
    | fzf --reverse --border \
    | xargs swaymsg exec --
