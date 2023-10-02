{ config, pkgs, ... }:

{
  home.username = "lapis";
  home.homeDirectory = "/Users/lapis";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    bottom
    gh
    ripgrep
    tldr
    aws-vault
    jq
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    defaultKeymap = "viins";
    initExtra = ''
      export PATH="$PATH:$HOME/.local/bin"
      if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';
    profileExtra = ''
      export EDITOR='vim'
    '';
  };

  programs.rtx = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font Medium";
      size = 16;
    };
    keybindings = {
      "ctrl+." = "next_tab";
      "ctrl+," = "previous_tab";
      "ctrl+t" = "new_tab_with_cwd";
      "ctrl+0" = "goto_tab 1";
      "ctrl+1" = "goto_tab 2";
      "ctrl+2" = "goto_tab 3";
      "ctrl+3" = "goto_tab 4";
      "ctrl+4" = "goto_tab 5";
    };
    settings = {
      adjust_line_height = "100%";
      cursor_blink_interval = "0";
      window_padding_width = "5";
      hide_window_decorations = "no";
      remember_window_size = "no";
      initial_window_width = "1000";
      initial_window_height = "650";
      enable_audio_bell = "no";
      confirm_os_window_close = "10";
      tab_separator = "|";
      tab_bar_margin_width = "0.0";
      tab_bar_style = "separator";
    };
  };

  imports = [
    ../../user-config/command-not-found.nix
    ../../user-config/direnv.nix
    ../../user-config/eza.nix
    ../../user-config/fzf.nix
    ../../user-config/git.nix
    ../../user-config/neovim.nix
    ../../user-config/starship.nix
    ../../user-config/tmux.nix
    ../../user-config/vim.nix
    ../../user-config/zoxide.nix
  ];
}
