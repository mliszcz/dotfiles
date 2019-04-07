#!/usr/bin/env bash

STATUS=$(~/.config/i3blocks/battery.sh | head -n 1)
CAPACITY=$(echo "$STATUS" | sed -E 's/^[^0-9]+([0-9]+)%.*$/\1/g')

echo "$STATUS"

printf "\n"

if (( $CAPACITY < 10 )); then
  printf "critical"
elif (( $CAPACITY < 25 )); then
  printf "warning"
fi
