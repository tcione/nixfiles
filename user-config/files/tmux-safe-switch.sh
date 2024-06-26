#!/usr/bin/env bash

session_name="$1"
session_dir="$2"
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$session_name" -c "$session_dir"
  exit 0
fi

if ! tmux has-session -t "$session_name" 2> /dev/null; then
  tmux new-session -ds "$session_name" -c "$session_dir"
fi

if [[ -z $TMUX ]]; then
  tmux attach -t "$session_name"
else
  tmux switch-client -t "$session_name"
fi
