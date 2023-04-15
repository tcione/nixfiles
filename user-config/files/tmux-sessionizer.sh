  #!/usr/bin/env bash

  # Taken from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(find ~/Projects -mindepth 1 -maxdepth 1 -type d | fzf)
  fi

  if [[ -z $selected ]]; then
    exit 0
  fi

  selected_name=$(basename "$selected" | tr . _)

  tmux-safe-switch.sh "$selected_name" "$selected"
