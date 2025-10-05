# Simple alternative to both xinit and startx for starting a Xorg server
# TODO
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.displayServer == "x11") {
    user.packages = [ pkgs.sx ];
    hm.xdg.configFile = {
      "sx/sxrc" = {
        source = ./sxrc;
        executable = true;
      };
      "sx/gruvbox-dark".source = ./gruvbox-dark;
    };
  };
}
