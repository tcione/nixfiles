{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  imports =
    [
      ./hardware-configuration.nix
      ./configuration.nix
    ];
}
