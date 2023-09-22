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
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
      self,
      nixpkgs,
      hyprland,
      home-manager,
      darwin,
  }:
  let
    system = "x86_64-linux";
  in {
    darwinConfigurations = {
      MAC2022HJ49 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/MAC2022HJ49/default.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lapis = {
              imports = [
                ./hosts/MAC2022HJ49/home.nix
              ];
            };
          }
        ];
      };
    };

    nixosConfigurations = {
      sleepy-turtle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

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
