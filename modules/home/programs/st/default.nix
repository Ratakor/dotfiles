# Simple Terminal for X11
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
  config = mkIf prg.terminal.st.enable {
    self.programs.default.terminal = mkIf (prg.default.terminal.name == "st") {
      cmd = "st";
      cmdDir = "st -d";
    };

    user.packages = [ pkgs.suckless ];
  };
}
