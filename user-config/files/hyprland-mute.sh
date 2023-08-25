#!/usr/bin/env bash

pamixer -t
STATE=$(pamixer --get-mute)
VOLUME=$(pamixer --get-volume)

if [[ $STATE == "true" ]]; then
  notify-send " Volume"
else
  notify-send -h int:value:"$VOLUME" "  Volume"
fi
