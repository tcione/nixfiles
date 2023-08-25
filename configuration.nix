{ config, pkgs, ... }:

let
  cleanup = pkgs.writeTextFile {
    name = "cleanup";
    destination = "/bin/cleanup";
    executable = true;
    text = ''
      sudo nix-collect-garbage -d
      sudo nix store gc
      sudo nix store optimise
      nix-collect-garbage -d
      nix store gc
      nix store optimise
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
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      package = pkgs._1password-gui-beta;
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
  environment.etc."polkit-gnome-authentication-agent-1".source = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

  environment.systemPackages = with pkgs; [
    # Basic tools
    vim
    wget
    zsh
    git
    gcc
    go
    cleanup
    polkit_gnome
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  fonts.packages = with pkgs; [
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

  # nixpkgs.overlays = [
  # ];
}

