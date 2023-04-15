{ config, pkgs, ... }:

{
  home.file."./.local/bin/setup-idleness.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      swayidle -d -w \
        timeout 300 'lock-system.sh' \
        timeout 360 'hyprctl dispatch dpms off' \
          resume 'hyprctl dispatch dpms on' \
        before-sleep 'lock-system.sh'
    '';
  };

  home.file."./.local/bin/lock-system.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      swaylock \
          --daemonize \
          --screenshots \
          --clock \
          --indicator \
          --indicator-radius 100 \
          --indicator-thickness 7 \
          --effect-blur 7x5 \
          --effect-vignette 0.5:0.5 \
          --font "Fira Sans" \
          --text-color cdd6f4 \
          --ring-color b4befe \
          --key-hl-color ffffff66 \
          --line-color 00000000 \
          --inside-color 1e1e2e88 \
          --separator-color 00000000 \
          --ring-ver-color 89dceb \
          --line-ver-color 00000000 \
          --inside-ver-color 1e1e2e88 \
          --text-ver-color cdd6f4 \
          --ring-clear-color fab387 \
          --line-clear-color 00000000 \
          --inside-clear-color 1e1e2e88 \
          --text-clear-color cdd6f4 \
          --ring-wrong-color f38na8 \
          --line-wrong-color 00000000 \
          --inside-wrong-color 1e1e2e88 \
          --text-wrong-color cdd6f4 \
          --grace 2 \
          --fade-in 0.2
    '';
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
    style = ''
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;

      * {
          border: none;
          border-radius: 0;
          font-family: "Fira Sans";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: none;
          color: white;
      }

      #window {
          font-weight: bold;
          font-family: "Fira Sans";
      }

      .modules-left,
      .modules-right {
          border-radius: 10px;
          background: @base;
          opacity: 0.9;
          margin: 4px 4px 2px 4px;
          padding: 8px 12px;
          border: 1px solid rgba(255, 255, 255, 0.3);
      }

      #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: @text;
      }

      #workspaces button.active {
          color: @peach;
      }

      .modules-right label {
          padding-left: 4px;
          padding-right: 4px;
      }

      #tray {
          padding-left: 8px;
          padding-right: 8px;
      }

      #clock {
          font-weight: bold;
          padding-left: 8px;
          padding-right: 8px;
      }

      #battery.warning {
          background: none;
          color: @peach;
      }

      #battery.critical {
          background: none;
          color: @red;
      }

      #network.disconnected {
          background: none;
          color: @red;
      }
    '';
  };

  home.file."./.config/hypr/themes/mocha.conf" = {
    executable = false;
    text = ''
      $rosewater = 0xfff5e0dc
      $flamingo  = 0xfff2cdcd
      $pink      = 0xfff5c2e7
      $mauve     = 0xffcba6f7
      $red       = 0xfff38ba8
      $maroon    = 0xffeba0ac
      $peach     = 0xfffab387
      $green     = 0xffa6e3a1
      $teal      = 0xff94e2d5
      $sky       = 0xff89dceb
      $sapphire  = 0xff74c7ec
      $blue      = 0xff89b4fa
      $lavender  = 0xffb4befe

      $text      = 0xffcdd6f4
      $subtext1  = 0xffbac2de
      $subtext0  = 0xffa6adc8

      $overlay2  = 0xff9399b2
      $overlay1  = 0xff7f849c
      $overlay0  = 0xff6c7086

      $surface2  = 0xff585b70
      $surface1  = 0xff45475a
      $surface0  = 0xff313244

      $base      = 0xff1e1e2e
      $mantle    = 0xff181825
      $crust     = 0xff11111b
    '';
  };

  home.file."./.local/bin/logout.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      session=`loginctl session-status | head -n 1 | awk '{print $1}'`
      loginctl terminate-session $session
    '';
  };

  home.file."./.config/hypr/hyprland.conf" = {
    executable = false;
    text = ''
      env = SDL_VIDEODRIVER,wayland
      env = MOZ_ENABLE_WAYLAND,1
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_QPA_PLATFORM,"wayland;xcb"
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = SDL_VIDEODRIVER,wayland
      env = _JAVA_AWT_WM_NONEREPARENTING,1
      env = CLUTTER_BACKEND,"wayland"
      # env = export GDK_BACKEND,"wayland"

      # Please note not all available settings / options are set here.
      # For a full list, see the wiki
      #

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,1
      monitor=eDP-1,preferred,auto,1.5
      monitor=DP-1,addreserved,1,2,1,1
      monitor=DP-2,2560x1440@144,0x0,1
      monitor=eDP-1,addreserved,1,2,1,1

      wsbind=1,DP-1
      wsbind=2,DP-1
      wsbind=3,DP-1
      wsbind=4,DP-1
      wsbind=5,DP-1

      exec-once = swaybg -o \* -i ~/Pictures/Backgrounds/bosma_lisbon_final.jpg -m fill
      exec-once = waybar
      exec-once = dunst
      exec-once = gammastep-indicator
      exec-once = blueman-applet
      exec-once = 1password --silent
      exec-once = mullvad-vpn
      exec-once = setup-idleness.sh

      # Source a file (multi-file configs)
      source=~/.config/hypr/themes/mocha.conf

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          repeat_delay = 300
          repeat_rate = 150
          kb_layout = us
          kb_variant = mac
          kb_model =
          kb_options = lv3:rwin_switch,ctrl:nocaps
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          gaps_in = 2
          gaps_out = 2
          border_size = 1
          col.active_border = rgba(ff89b4aa)
          col.inactive_border = rgba(595959aa)
          layout = dwindle
      }

      decoration {
          rounding = 10
          inactive_opacity = 1.0
          blur = no
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = on
          drop_shadow = no
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = yes
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes # you probably want this
      }

      master {
          new_is_master = true
      }

      gestures {
          workspace_swipe = off
      }

      device:epic mouse V1 {
          sensitivity = -0.5
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Return, exec, kitty
      # bind = $mainMod, C, killactive,
      # bind = $mainMod, W, killactive,
      bind = $mainMod, Q, killactive,
      bind = $mainMod, E, exec, thunar
      bind = $mainMod, Space, togglefloating,
      bind = $mainMod, M, fullscreen, 1
      bind = $mainMod, F, fullscreen, 0
      bind = $mainMod, D, exec, wofi --allow-images --show drun --define=key_expand=space
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, T, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      bind = $mainMod , minus , togglespecialworkspace,
      bind = $mainMod SHIFT, minus , movetoworkspace , special

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1
      bind = $mainMod, TAB, cyclenext
      bind = $mainMod SHIFT, TAB, swapnext

      bind = , XF86MonBrightnessUp , exec , light -T 1.4 && notify-send -h int:value:$(light -G) " Brightness"
      bind = SHIFT , XF86MonBrightnessUp , exec , light -A 1 && notify-send -h int:value:$(light -G) " Brightness"
      bind = , XF86MonBrightnessDown , exec , light -T 0.72 && notify-send -h int:value:$(light -G) " Brightness"
      bind = SHIFT , XF86MonBrightnessDown , exec , light -U 1 && notify-send -h int:value:$(light -G) " Brightness"

      bind = , XF86AudioRaiseVolume , exec , pamixer -i 5 && notify-send -h int:value:$(pamixer --get-volume) "  Volume"
      bind = , XF86AudioLowerVolume , exec , pamixer -d 5 && notify-send -h int:value:$(pamixer --get-volume) "  Volume"
      bind = , XF86AudioMute , exec , pamixer -t && notify-send -h int:value:$(pamixer --get-volume) "Volume /"

      bind = , XF86AudioMedia , exec , wofi-power-menu

      bind = , XF86AudioPlay , exec , dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
      bind = , XF86AudioNext , exec , dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
      bind = , XF86AudioPrev , exec , dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous

      bind = , Print , exec , grim -t jpeg ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).jpg

      # Take a Screenshot with the region select
      bind = $mainMod , Print , exec , grim -t jpeg -g "$(slurp)" ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).jpg

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      windowrulev2 = workspace 5 silent,class:^(signal)$
      windowrulev2 = float,title:^(.*?Sharing Indicator)$
      windowrulev2 = move 100%-122 100%-42,title:^(.*?Sharing Indicator)$
      windowrulev2 = size 110 30,title:^(.*?Sharing Indicator)$
    '';
  };
}
