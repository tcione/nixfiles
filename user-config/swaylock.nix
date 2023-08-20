{ config, pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      image = "/home/tortoise/Pictures/Backgrounds/Bosma_cookie_cat.jpg";
      scaling = "tile";
      color = "1e1e2e88";
      font = "Fira Sans";
      text-color = "cdd6f4";
      ring-color = "b4befe";
      key-hl-color = "ffffff66";
      line-color = "00000000";
      inside-color = "1e1e2e88";
      separator-color = "00000000";
      ring-ver-color = "89dceb";
      line-ver-color = "00000000";
      inside-ver-color = "1e1e2e88";
      text-ver-color = "cdd6f4";
      ring-clear-color = "fab387";
      line-clear-color = "00000000";
      inside-clear-color = "1e1e2e88";
      text-clear-color = "cdd6f4";
      ring-wrong-color = "f38na8";
      line-wrong-color = "00000000";
      inside-wrong-color = "1e1e2e88";
      text-wrong-color = "cdd6f4";
      indicator-radius = "100";
      indicator-thickness = "7";
    };
  };
}
