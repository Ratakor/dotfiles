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
  inherit (lib.trivial) unreachable;

  prg = config.self.programs;
in
{
  config = mkIf prg.statusBar.sb.enable {
    self.programs.default.statusBar = mkIf (prg.default.statusBar.name == "sb") {
      toggle = unreachable; # TODO
    };

    user.packages = [ pkgs.suckless ];
    hm.xdg.configFile."sb/config".source = ./config;
  };
}
