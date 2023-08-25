#!/usr/bin/env bash
#
systemd-inhibit sh -c 'x=1; while  [ $x = "1" ]; do echo "Sip..."; sleep 1 ; done'
