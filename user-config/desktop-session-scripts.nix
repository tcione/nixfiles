{ config, pkgs, ... }:

{
  home.file."./.local/bin/logout.sh" = {
    executable = true;
    source = ./files/logout.sh;
  };

  home.file."./.local/bin/power-menu.sh" = {
    executable = true;
    source = ./files/power-menu.sh;
  };

  home.file."./.local/bin/hyprland-mute.sh" = {
    executable = true;
    source = ./files/hyprland-mute.sh;
  };
}
