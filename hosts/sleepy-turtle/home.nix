{ config, pkgs, ... }:

{
  home.username = "tortoise";
  home.homeDirectory = "/home/tortoise";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    bottom
    clang
    darktable
    discord
    fd
    gh
    gimp-with-plugins
    gnumake
    lm_sensors
    neofetch
    obsidian
    orpie
    ripgrep
    signal-desktop
    spotify
    tcl
    tldr
    unzip
    via
    zip
    rclone
    todoist-electron
    go
    synology-drive-client
    xfce.xfconf

    # Browsers, gee, I sure have lots
    qutebrowser
    librewolf
    firefox
    google-chrome
    ungoogled-chromium

    # Desktop
    clipman
    grim
    hyprpicker
    kooha
    networkmanagerapplet
    slurp
    swaybg
    udiskie
    wl-clipboard
    # - Session
    swayidle
    # - Media
    pavucontrol
    pamixer
    evince
    playerctl
    font-manager
    vimiv-qt
    mpv
    libheif
    # - Notifications
    libnotify
    # - GTK stuff
    catppuccin-gtk
    catppuccin-cursors
    glib
    gnome3.adwaita-icon-theme
    # - File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.tumbler
  ];

  imports = [
    ../../user-config/command-not-found.nix
    ../../user-config/dconf.nix
    ../../user-config/desktop-session-scripts.nix
    ../../user-config/direnv.nix
    ../../user-config/dunst.nix
    ../../user-config/eza.nix
    ../../user-config/fzf.nix
    ../../user-config/gammastep.nix
    ../../user-config/git.nix
    ../../user-config/gtk.nix
    ../../user-config/hyprland.nix
    ../../user-config/imv.nix
    ../../user-config/kitty.nix
    ../../user-config/neovim.nix
    ../../user-config/starship.nix
    ../../user-config/swaylock.nix
    ../../user-config/tmux.nix
    ../../user-config/vim.nix
    ../../user-config/waybar.nix
    ../../user-config/wofi.nix
    ../../user-config/zoxide.nix
    ../../user-config/zsh.nix
  ];
}
