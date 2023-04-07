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
    gcc
    go
    cleanup

    # Desktop
    # - Session
    swaylock-effects
    swayidle
    enable-swayidle
    lock-system
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

