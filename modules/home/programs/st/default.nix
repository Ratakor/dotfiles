# Simple Terminal for X11
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
  config = mkIf (config.self.programs.terminal.program == "st") {
    user.packages = [ self.pkgs.suckless ];

    self.programs.terminal = {
      cmd = "st";
      cmdDir = "st -d";
    };
  };
}
