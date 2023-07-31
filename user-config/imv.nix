{ config, pkgs, ... }:

{
  programs.imv = {
    enable = true;
    settings = {
      binds = {
        "<Shift+X>" = "exec rm \"$imv_current_file\"; close";
        "<Shift+R>" = "exec mogrify -rotate 90 \"$imv_current_file\"";
      };
    };
  };
}
