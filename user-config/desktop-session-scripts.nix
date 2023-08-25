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

  home.file."./.local/bin/coffee-sip.sh" = {
    executable = true;
    source = ./files/coffee-sip.sh;
  };

  home.file."./.local/bin/coffee-toggle.sh" = {
    executable = true;
    source = ./files/coffee-toggle.sh;
  };

  home.file."./.local/bin/coffee-status.sh" = {
    executable = true;
    source = ./files/coffee-status.sh;
  };
}
