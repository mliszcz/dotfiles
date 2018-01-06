#!/usr/bin/env bash

FA_SITEMAP=
FA_WIFI=

if [[ -n $BLOCK_INSTANCE ]]; then
  IF=$BLOCK_INSTANCE
else
  IF=$(ip route | awk '/^default/ { print $5 ; exit }')
fi

[[ -d "/sys/class/net/$IF/wireless" ]] && ICON=$FA_WIFI || ICON=$FA_SITEMAP

/usr/lib/i3blocks/iface | awk "{ printf (NR<=2)?\"$ICON \":\"\"; print }"
