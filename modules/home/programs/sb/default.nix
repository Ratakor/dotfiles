# sb: statusbar
# A simple status bar for dwm
# crontab btw
#*/30 * * * * kill -49 $(pidof sb); randwp
#0 0 * * * kill -48 $(pidof sb)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
in
{
  config = mkIf prg.statusBar.sb.enable {
    user.packages = [ pkgs.suckless ];
    hm.xdg.configFile."sb/config".source = ./config;
  };
}
