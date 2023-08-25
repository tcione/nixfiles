#!/usr/bin/env bash

SIP_COFFEE_PID=$(pgrep -f coffee-sip.sh)

if [[ -n $SIP_COFFEE_PID ]]; then
  kill -9 "$SIP_COFFEE_PID"
else
  bash ./coffee-sip.sh > /dev/null 2>&1 &
fi
