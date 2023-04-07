{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      tmux-fzf
      fzf-tmux-url
      {
        plugin = prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_fg '#A6E3A1'
          set -g @prefix_highlight_bg '#1E1E2E'
        '';
      }
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-command 'echo -n {} | wl-copy'
        '';
      }
    ];
    extraConfig = ''
      set -g status-left-length 32
      set -g status-right '#{prefix_highlight} | %a %h-%d %H:%M'
      set -g status-style fg=#A6E3A1,bg=#1E1E2E

      set-option -g allow-rename off
      set -g default-shell $SHELL
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      bind-key c new-window -c '#{pane_current_path}'
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      unbind '"'
      unbind %

      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind-key -r H run-shell "~/.local/bin/tmux-init"
      unbind C
      bind-key -r C run-shell "tmux neww ~/.local/bin/tmux-sessionizer.sh"
    '';
  };

  home.file."./.local/bin/tmux-init.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      tmux-safe-switch.sh "home" "$HOME"
    '';
  };

  home.file."./.local/bin/tmux-sessionizer.sh" = {
    executable = true;
    text = ''
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
    '';
  };

  home.file."./.local/bin/tmux-safe-switch.sh" = {
    executable = true;
    text = ''
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
    '';
  };
}
