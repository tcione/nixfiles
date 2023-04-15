{ config, pkgs, ... }:

{
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 52.52;
    longitude = 13.40;
    settings = {
      general = {
        adjustment-method = "wayland";
        fade = 1;
      };
    };
    temperature = {
      day = 6500;
      night = 2800;
    };
    tray = true;
  };
}
