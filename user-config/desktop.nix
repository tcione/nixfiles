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


  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Catppuccin-Mocha-Dark-Cursors";
      };
    };
  };


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

  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = "64x64";
    };
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 370;
        height = 370;
        origin = "top-right";
        offset = "10x10";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 12;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 362;
        progress_bar_max_width = 362;
        progress_bar_corner_radius = 0;
        highlight = "#FFFFFFFF";
        indicate_hidden = "yes";
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 1;
        frame_color = "#77777780";
        gap_size = 4;
        separator_color = "frame";
        sort = "yes";
        font = "Noto Sans 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        sticky_history = "yes";
        history_length = 20;
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 5;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      experimental = { per_monitor_dpi = false; };
      urgency_low = {
        background = "#313244DF";
        foreground = "#CDD6F4";
        frame_color = "#45475ADF";
        timeout = 10;
      };
      urgency_normal = {
        background = "#313244DF";
        foreground = "#CDD6F4";
        frame_color = "#45475ADF";
        timeout = 10;
      };
      urgency_critical = {
        background = "#F38BA8DF";
        foreground = "#CDD6F4";
        frame_color = "#F2CDCDDF";
        timeout = 0;
      };
      category_progress = {
        category = "progress";
        width = 500;
        height = 500;
        origin = "center-center";
        offset = "0x0";
      };
    };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 52.52;
    longitude = 13.40;
    settings = {
      general = {
        adjustment-method = "wayland";
        fade = 1;
      };
    };
    temperature = {
      day = 6500;
      night = 2800;
    };
    tray = true;
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        spacing = 4;
        modules-left = [ "wlr/workspaces" ];
        modules-center = [];
        modules-right = [
          "tray"
          "pulseaudio"
          "backlight"
          "network"
          # "cpu"
          # "memory"
          # "temperature"
          "battery"
          "clock"
        ];
        "wlr/workspaces" = {
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
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
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
          format-bluetooth = "{volume}% {icon}   {format_source}";
          format-bluetooth-muted = "  {icon}   {format_source}";
          format-muted = "  {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
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
        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
        };
      };
    };
    style = ./files/waybar-style.css;
  };

  home.file."./.config/hypr/themes/mocha.conf" = {
    executable = false;
    source = ./files/hypr-themes-mocha.conf;
  };

  home.file."./.config/hypr/hyprland.conf" = {
    executable = false;
    source = ./files/hyprland.conf;
  };
}
