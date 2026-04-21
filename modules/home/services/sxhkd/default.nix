# Simple Hotkey Daemon for X11
# TODO
# see hm.services.sxhkd
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
    user.packages = [ pkgs.sxhkd ];
    hm.xdg.configFile."sxhkd/sxhkdrc".source = ./sxhkdrc;
  };
}
