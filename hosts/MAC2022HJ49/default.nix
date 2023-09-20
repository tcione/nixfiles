{ pkgs, ... }:
{
  services.nix-daemon.enable = true;
  services.nix-daemon.package = pkgs.nixFlakes;
  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    autoupdate = true;
    casks = [];
  };

  sytem.defaults = {
    dock.autohide = true;
  }

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.lapis = { pkgs, ... }: {
      stateVersion = "23.05";
    }
  };
}
