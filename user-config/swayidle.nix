{ config, pkgs, ... }:

{
  programs.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "lock-system.sh"; }
      { event = "lock"; command = "lock-system.sh"; }
    ];
    timeouts = [
      { timeout = 300; command = "lock-system.sh"; }
      { timeout = 360; command = "hyprctl dispatch dpms off"; resumeCommand = "htprctl dispatch dpms on"; }
    ];
    systemdTarget = "graphical-session.target";
  };
}
