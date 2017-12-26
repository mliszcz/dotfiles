#!/usr/bin/env bash

FA_BATTERY_FULL=
FA_BATTERY_THREE_QUARTERS=
FA_BATTERY_HALF=
FA_BATTERY_QUARTER=
FA_BATTERY_EMPTY=
FA_BOLT=
FA_PLUG=
FA_QUESTION=

BATTERY_PREFIX="Battery ${BLOCK_INSTANCE:-0}: "

ADAPTER=`acpi -a | grep "Adapter 0"`
BATTERY=`acpi -b | grep "$BATTERY_PREFIX"`

PERCENT='([[:digit:]]{1,2})%'
TIME='([[:digit:]]{2}:[[:digit:]]{2}):[[:digit:]]{2}'
TEXT='[[:print:]]*'

# syntax: https://sourceforge.net/p/acpiclient/code/ci/master/tree/acpi.c
# some examples:
# Battery 0: Discharging, 6%, 00:21:16 remaining
# Battery 0: Charging, 6%, charging at zero rate - will never fully charge.
# Battery 0: Charging, 6%, 01:18:29 until charged
# Battery 0: Unknown, 99%

function print-icon() (
  shopt -s nocasematch
  case "$1" in
    charging)
      printf $FA_BOLT
      ;;
    discharging)
      if (($2 < 20)); then printf $FA_BATTERY_EMPTY;
      elif (($2 < 40)); then printf $FA_BATTERY_QUARTER;
      elif (($2 < 60)); then printf $FA_BATTERY_HALF;
      elif (($2 < 85)); then printf $FA_BATTERY_THREE_QUARTERS;
      else printf $FA_BATTERY_FULL;
      fi
      ;;
    *)
      [[ "$ADAPTER" == *on-line* ]] && printf $FA_PLUG || printf $FA_QUESTION
      ;;
  esac
)

function print-color() (
  shopt -s nocasematch
  if [[ "$1" == discharging ]]; then
    if (($2 < 20)); then printf "#FF0000\n";
    elif (($2 < 40)); then printf "#FFAE00\n";
    elif (($2 < 60)); then printf "#FFF600\n";
    elif (($2 < 85)); then printf "#A8FF00\n";
    fi
    if (($2 < 5 )); then
      exit 33
    fi
  fi
)

function print-status() {
  local STATUS PERCENT TIME
  read STATUS PERCENT TIME
  ICON=`print-icon "$STATUS" $PERCENT`
  TIME=`[[ -n "$TIME" ]] && printf " ($TIME)"`
  printf "$ICON $PERCENT%%$TIME\n"
  printf "$ICON $PERCENT%%\n"
  print-color "$STATUS" $PERCENT
}

echo "${BATTERY#$BATTERY_PREFIX}" \
  | sed -Ee "s/^($TEXT), $PERCENT(, $TIME)?$TEXT$/\1 \2 \4/g" \
  | print-status

