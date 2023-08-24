{ config, pkgs, ... }:

{
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
        origin = "center";
        offset = "0x0";
      };
    };
  };
}
