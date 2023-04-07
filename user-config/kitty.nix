{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font = {
      package = pkgs.fira-code-symbols;
      name = "Fira Code Medium";
      size = 12;
    };
    keybindings = {
      "ctrl+." = "next_tab";
      "ctrl+," = "previous_tab";
      "ctrl+t" = "new_tab_with_cwd";
      "ctrl+0" = "goto_tab 1";
      "ctrl+1" = "goto_tab 2";
      "ctrl+2" = "goto_tab 3";
      "ctrl+3" = "goto_tab 4";
      "ctrl+4" = "goto_tab 5";
    };
    settings = {
      adjust_line_height = "100%";
      cursor_blink_interval = "0";
      window_padding_width = "5";
      hide_window_decorations = "no";
      remember_window_size = "no";
      initial_window_width = "1000";
      initial_window_height = "650";
      enable_audio_bell = "no";
      confirm_os_window_close = "10";
      tab_separator = "|";
      tab_bar_margin_width = "0.0";
      tab_bar_style = "separator";
    };
  };
}
