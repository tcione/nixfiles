{ config, pkgs, ... }:

{
  programs.exa = {
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
