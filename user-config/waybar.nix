{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "custom/system"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ ];
        modules-right = [
          "tray"
          "idle_inhibitor"
          "pulseaudio"
          "backlight"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "network"
          "clock"
          "custom/power"
        ];
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          on-click = "activate";
          format = "{name}: {icon}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
        };
        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = ["" ""];
        };
        tray = {
          spacing = 10;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            deactivated = "";
            activated = "";
            tooltip = false;
          };
        };
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%Y-%m-%d %H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M:%S}";
          on-click-right = "firefox --new-window https://calendar.google.com";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
          on-click = "kitty --class tuibtm btm";
        };
        memory = {
          format = "{}% ";
          on-click = "kitty --class tuibtm btm";
        };
        temperature = {
          format = "{temperatureC}°C ";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "";
          tooltip-format = "{ipaddr}/{cidr} @ {ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = " ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = " {icon}  {format_source}";
          format-muted = " {format_source}";
          format-source = "| {volume}% ";
          format-source-muted = "| ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        "custom/system" = {
          format = "";
          on-click = "kitty --class tuineofetch --hold neofetch";
        };
        "custom/power" = {
          format = "";
          on-click = "sleep 0.1 && ~/.local/bin/power-menu.sh";
        };
        "hyprland/window" = {
          format = "  [{class}] {title}";
          separate-outputs = true;
          rewrite = {
            ".*\\[Signal\\].*" = "  Signal";
            ".*\\[firefox\\] (.*) — Mozilla Firefox" = "  $1";
            ".*\\[kitty\\] (.*)" = "  $1";
            ".*\\[\\].*" = "٩(˘◡˘)۶";
          };
        };
      };
    };
    style = ./files/waybar-style.css;
  };
}
