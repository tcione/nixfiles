#!/usr/bin/env bash

SIP_COFFEE_PID=$(pgrep -f coffee-sip.sh)

if [[ -n $SIP_COFFEE_PID ]]; then
  echo "true"
else
  echo "false"
fi
