{ config, pkgs, ... }:

let
  cleanup = pkgs.writeTextFile {
    name = "cleanup";
    destination = "/bin/cleanup";
    executable = true;
    text = ''
      nix-collect-garbage --delete-older-than 7d
      nix-store --optimise
    '';
  };

  wofi-power-menu = pkgs.writeTextFile {
    name = "wofi-power-menu";
    destination = "/bin/wofi-power-menu";
    executable = true;
    text = ''
      entries="⇠ Logout\n⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"
      selected=$(echo -e $entries|wofi --width 250 --height 210 --dmenu --cache-file /dev/null --insentitive | awk '{print tolower($2)}')

      case $selected in
        logout)
          swaymsg exit;;
        suspend)
          exec systemctl suspend;;
        reboot)
          exec systemctl reboot;;
        shutdown)
          exec systemctl poweroff -i;;
      esac
    '';
  };

  enable-swayidle = pkgs.writeTextFile {
    name = "enable-swayidle";
    destination = "/bin/enable-swayidle";
    executable = true;
    text = ''
      swayidle -w \
        timeout 300 'lock-system' \
        timeout 600 'hyprctl dispatch dpms off' \
        resume 'hyprctl dispatch dpms on' \
        before-sleep 'lock-system'
    '';
  };

  lock-system = pkgs.writeTextFile {
    name = "lock-system";
    destination = "/bin/lock-system";
    executable = true;
    text = ''
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

  # Taken from https://nixos.wiki/wiki/Sway
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland SSH_AUTH_SOCK
      systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-hyprland
      systemctl --user start pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-hyprland
    '';
  };

  # Taken from https://nixos.wiki/wiki/Sway
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema color-scheme 'prefer-dark'
      gsettings set $gnome_schema gtk-theme 'Dracula'
      gsettings set $gnome_schema icon-theme "Dracula"
      '';
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };


  networking = {
    hostName = "sleepy-turtle";

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
    ];

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      wifi.powersave = false;
    };

    wireless.iwd.settings.Network.EnableIPv6 = false;
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.utf8";
    LC_IDENTIFICATION = "pt_BR.utf8";
    LC_MEASUREMENT = "pt_BR.utf8";
    LC_MONETARY = "pt_BR.utf8";
    LC_NAME = "pt_BR.utf8";
    LC_NUMERIC = "pt_BR.utf8";
    LC_PAPER = "pt_BR.utf8";
    LC_TELEPHONE = "pt_BR.utf8";
    LC_TIME = "pt_BR.utf8";
  };

  services.dbus.enable = true;
  services.printing.enable = true;
  services.fprintd.enable = true;

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  programs.ssh.startAgent = true;

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  programs.light.enable = true;

  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "tortoise" ];
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  security.pam.services.swaylock = {};

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  users.users.tortoise = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      brave
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  environment.systemPackages = with pkgs; [
    # Basic tools
    vim
    wget
    zsh
    git
    tmux
    direnv
    gcc
    go
    cleanup

    # Desktop
    wofi
    waybar
    networkmanagerapplet
    geoclue2
    dbus-hyprland-environment
    swaybg
    grim
    slurp
    wl-clipboard
    # - Session
    swaylock-effects
    swayidle
    enable-swayidle
    lock-system
    wofi-power-menu
    # - Notifications
    dunst
    glib
    libnotify
    # - Media
    pavucontrol
    pamixer
    imv
    evince
    font-manager
    playerctl
    vlc
    # - GTK stuff
    dracula-theme
    configure-gtk
    glib
    gnome3.adwaita-icon-theme
    # - File manager
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.tumbler

    # Software
    _1password-gui
    signal-desktop
    darktable
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  fonts.fonts = with pkgs; [
    font-awesome
    fira
    fira-code
    fira-code-symbols
    fira-mono
    dejavu_fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ubuntu_font_family
    roboto-slab
    liberation_ttf
  ];
  fonts.fontconfig = {
    defaultFonts = {
      monospace = [
        "Fira Code"
        "DejaVu Sans Mono"
        "Noto Mono"
      ];
      sansSerif = [
        "Fira Sans"
        "Ubuntu"
        "DejaVu Sans"
        "Noto Sans"
      ];
      serif = [
        "Roboto Slab"
        "Liberation Serif"
        "Noto Serif"
      ];
    };
  };


  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
}

