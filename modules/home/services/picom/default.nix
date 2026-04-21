# X11 Compositor (window transparency and stuff)
# TODO
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  sys = config.self.system;
in
{
  config = mkIf sys.displayServer.x11 {
    user.packages = [ pkgs.picom ];
    hm.xdg.configFile."picom.conf".source = ./picom.conf;
  };
}
