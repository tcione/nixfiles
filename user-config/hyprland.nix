{ config, pkgs, ... }:

{
  home.file."./.config/hypr/themes/mocha.conf" = {
    executable = false;
    source = ./files/hypr-themes-mocha.conf;
  };

  home.file."./.config/hypr/hyprland.conf" = {
    executable = false;
    source = ./files/hyprland.conf;
  };
}
