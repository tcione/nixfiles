{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Peach-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "peach" ];
        size = "standard";
        tweaks = [ ];
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
    };
  };
}
