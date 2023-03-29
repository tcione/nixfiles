{
  description = "Personal nix config for sleepy turtle";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
      self,
      nixpkgs,
      nixpkgs-unstable,
      hyprland,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      sleepy-turtle = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          hyprland.nixosModules.default { programs.hyprland.enable = true; }
          ./configuration.nix
        ];
      };
    };
  };
}
