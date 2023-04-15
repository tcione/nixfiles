#!/usr/bin/env bash

swayidle -d -w \
  timeout 300 'lock-system.sh' \
  timeout 360 'hyprctl dispatch dpms off' \
    resume 'hyprctl dispatch dpms on' \
  before-sleep 'lock-system.sh'
