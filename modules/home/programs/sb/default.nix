# sb: statusbar
# A simple status bar for dwm
# crontab btw
#*/30 * * * * kill -49 $(pidof sb); randwp
#0 0 * * * kill -48 $(pidof sb)
{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.system.displayServer == "x11") {
    user.packages = [ self.pkgs.suckless ];
    hm.xdg.configFile."sb/config".source = ./config;
  };
}
