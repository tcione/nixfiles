{
  description = "Personal nix config for sleepy turtle";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
  } @ inputs:
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
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/sleepy-turtle/default.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tortoise = {
              imports = [
                ./hosts/sleepy-turtle/home.nix
              ];
            };
          }
        ];
      };
    };
  };
}
