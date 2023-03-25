{
  description = "Example NixOS Configuration";

  inputs = {
    nixpkgs = {
      url = github:nixos/nixpkgs?ref=nixos-22.11;
    };
  };

  outputs = {
      self,
      nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system} = {
      myPackage = pkgs.callPackage ./. {};
      default = self.packages.${system}.myPackage;
    };

    nixosConfigurations = {
      mutant = nixpkgs.lib.nixosSystem {
        inherit pkgs system;

        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
