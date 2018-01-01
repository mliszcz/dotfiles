#!/usr/bin/env bash

# Battery status indication script for i3blocks.
#
# MIT License
#
# Copyright (c) 2018 Michal Liszcz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

shopt -s nocasematch

FA_BATTERY_FULL=
FA_BATTERY_THREE_QUARTERS=
FA_BATTERY_HALF=
FA_BATTERY_QUARTER=
FA_BATTERY_EMPTY=
FA_BOLT=
FA_PLUG=
FA_QUESTION=

BATTERY="/sys/class/power_supply/${BLOCK_INSTANCE:-BAT1}"
ADAPTER="/sys/class/power_supply/AC"

mapfile -t -n 1 AC_ONLINE < $ADAPTER/online
mapfile -t -n 1 BAT_STATUS < $BATTERY/status
mapfile -t -n 1 BAT_ENERGY_NOW < $BATTERY/energy_now
mapfile -t -n 1 BAT_ENERGY_FULL < $BATTERY/energy_full
mapfile -t -n 1 BAT_POWER_NOW < $BATTERY/power_now

function print-icon() {
  case "$BAT_STATUS" in
    charging)
      printf $FA_BOLT
      ;;
    discharging)
      if (($1 < 20)); then printf $FA_BATTERY_EMPTY;
      elif (($1 < 40)); then printf $FA_BATTERY_QUARTER;
      elif (($1 < 60)); then printf $FA_BATTERY_HALF;
      elif (($1 < 85)); then printf $FA_BATTERY_THREE_QUARTERS;
      else printf $FA_BATTERY_FULL;
      fi
      ;;
    *)
      [[ "$AC_ONLINE" == 1 ]] && printf $FA_PLUG || printf $FA_QUESTION
      ;;
  esac
}

function print-color() {
  if [[ "$BAT_STATUS" == discharging ]]; then
    if (($1 < 20)); then printf "#FF0000";
    elif (($1 < 40)); then printf "#FFAE00";
    elif (($1 < 60)); then printf "#FFF600";
    elif (($1 < 85)); then printf "#A8FF00";
    fi
  fi
}

function print-time() {
  local ENERGY SECONDS
  case "$BAT_STATUS" in
    charging) ENERGY=$(($BAT_ENERGY_FULL-$BAT_ENERGY_NOW)) ;;
    discharging) ENERGY=$BAT_ENERGY_NOW ;;
    *) ENERGY= ;;
  esac
  if [[ -n $ENERGY ]] && (($BAT_POWER_NOW > 0)); then
    SECONDS=$((60*60*$ENERGY/$BAT_POWER_NOW))
    date -u +%H:%M -d@$SECONDS
  fi
}

CAPACITY=$((100*$BAT_ENERGY_NOW/$BAT_ENERGY_FULL))
ICON=$(print-icon $CAPACITY)
TIME=$(print-time)
COLOR=$(print-color $CAPACITY)

[[ -n "$TIME" ]] && TIME=" ($TIME)"

printf "$ICON $CAPACITY%%$TIME\n"
printf "$ICON $CAPACITY%%\n"
[[ -n "$COLOR" ]] && printf "$COLOR\n"

if [[ "$BAT_STATUS" == discharging ]] && (($CAPACITY < 5)); then
  exit 33
fi

