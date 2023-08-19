{ config, pkgs, ... }:

{
  home.username = "tortoise";
  home.homeDirectory = "/home/tortoise";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    bottom
    brave
    darktable
    discord
    fd
    firefox
    gh
    gimp-with-plugins
    neofetch
    obsidian
    orpie
    ripgrep
    signal-desktop
    spotify
    tldr
    unzip
    zip
    gnumake
    tcl
    via

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
    swaylock-effects
    swayidle
    # - Media
    pavucontrol
    pamixer
    evince
    playerctl
    vlc
    font-manager
    vimiv-qt
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
    xfce.tumbler
  ];

  imports = [
    ./user-config/command-not-found.nix
    ./user-config/dconf.nix
    ./user-config/desktop-session-scripts.nix
    ./user-config/direnv.nix
    ./user-config/dunst.nix
    ./user-config/exa.nix
    ./user-config/fzf.nix
    ./user-config/gammastep.nix
    ./user-config/git.nix
    ./user-config/gtk.nix
    ./user-config/hyprland.nix
    ./user-config/imv.nix
    ./user-config/kitty.nix
    ./user-config/neovim.nix
    ./user-config/starship.nix
    ./user-config/tmux.nix
    ./user-config/vim.nix
    ./user-config/waybar.nix
    ./user-config/wofi.nix
    ./user-config/zoxide.nix
    ./user-config/zsh.nix
  ];
}
