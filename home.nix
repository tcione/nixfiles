{ config, pkgs, ... }:

{
  home.username = "tortoise";
  home.homeDirectory = "/home/tortoise";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    exa
    bat
    fd
    bottom
    ripgrep

    discord
    spotify
    gimp-with-plugins
    brave
    firefox
    signal-desktop
    darktable

    # Desktop
    networkmanagerapplet
    swaybg
    grim
    slurp
    wl-clipboard
    # - Session
    swaylock-effects
    swayidle
    # - Media
    pavucontrol
    pamixer
    imv
    evince
    playerctl
    vlc
    font-manager
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
    ./user-config/desktop.nix
    ./user-config/direnv.nix
    ./user-config/fzf.nix
    ./user-config/git.nix
    ./user-config/kitty.nix
    ./user-config/neovim.nix
    ./user-config/starship.nix
    ./user-config/tmux.nix
    ./user-config/vim.nix
    ./user-config/zoxide.nix
    ./user-config/zsh.nix
  ];
}
