{ config, pkgs, ... }:

{
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "lock-system.sh"; }
      { event = "lock"; command = "lock-system.sh"; }
    ];
    timeouts = [
      { timeout = 60; command = "lock-system.sh"; }
      { timeout = 90; command = "hyprctl dispatch dpms off"; resumeCommand = "htprctl dispatch dpms on"; }
    ];
    systemdTarget = "graphical-session.target";
  };
}
