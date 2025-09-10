# Simple Terminal for X11
{
  config,
  lib,
  self,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.self.terminal.program == "st") {
    user.packages = [self.pkgs.suckless];

    self.terminal = {
      cmd = "st";
      cmdDir = "st -d";
    };
  };
}
