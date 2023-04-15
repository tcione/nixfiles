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
    source = ./files/tmux-init.sh;
  };

  home.file."./.local/bin/tmux-sessionizer.sh" = {
    executable = true;
    source = ./files/tmux-sessionizer.sh;
  };

  home.file."./.local/bin/tmux-safe-switch.sh" = {
    executable = true;
    source = ./files/tmux-safe-switch.sh;
  };
}
