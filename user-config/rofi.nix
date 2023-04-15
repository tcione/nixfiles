{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "kitty";
    theme = "./themes/catppuccin-mocha.rasi";
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Adwaita";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
  };

  home.file."./.config/rofi/themes/catppuccin-mocha.rasi" = {
    enable = true;
    source = ./files/catppuccin-mocha.rasi;
  };
}

