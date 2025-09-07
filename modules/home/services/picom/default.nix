# X11 Compositor (window transparency and stuff)
# TODO
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.self.displayServer == "x11") {
    user.packages = [pkgs.picom];
    hm.xdg.configFile."picom.conf".source = ./picom.conf;
  };
}
