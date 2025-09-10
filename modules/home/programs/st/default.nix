# Simple Terminal for X11
# TODO
{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.self.terminal.program == "st") {
    # user.packages = [st];

    self.terminal = {
      cmd = "st";
      cmdDir = "st -d";
    };
  };
}
