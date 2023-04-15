{ config, pkgs, ... }:

{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Catppuccin-Mocha-Dark-Cursors";
      };
    };
  };
}
