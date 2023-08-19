{
  description = "Personal nix config for sleepy turtle";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
      self,
      nixpkgs,
      hyprland,
      home-manager,
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      # overlays = [
        # (self: super: {
          # signal-desktop = super.signal-desktop.overrideAttrs (old: {
             # preFixup = old.preFixup + ''
               # gappsWrapperArgs+=(
                 # --add-flags "--ozone-platform=wayland"
               # )
             # '';
          # });
        # })
      # ];
    };
  in {
    nixosConfigurations = {
      sleepy-turtle = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          # { nixpkgs = { inherit pkgs; }; }
          hyprland.nixosModules.default
          {
            programs.hyprland = {
              enable = true;
              xwayland = {
                enable = true;
              };
            };
          }
          ./configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tortoise = {
              imports = [
                ./home.nix
              ];
            };
          }
        ];
      };
    };
  };
}
