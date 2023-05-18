{ config, pkgs, ... }:

{
  home.file."./.local/bin/setup-idleness.sh" = {
    executable = true;
    source = ./files/setup-idleness.sh;
  };

  home.file."./.local/bin/lock-system.sh" = {
    executable = true;
    source = ./files/lock-system.sh;
  };

  home.file."./.local/bin/logout.sh" = {
    executable = true;
    source = ./files/logout.sh;
  };

  home.file."./.local/bin/power-menu.sh" = {
    executable = true;
    source = ./files/power-menu.sh;
  };
}
