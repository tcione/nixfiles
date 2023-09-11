{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--all"
      "--long"
    ];
  };
}
