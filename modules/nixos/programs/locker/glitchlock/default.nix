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
  config = mkIf prg.locker.glitchlock.enable {
    self.programs.default.locker = mkIf (prg.default.locker.name == "glitchlock") {
      cmd = "glitchlock";
    };

    # glitchlock is backed by swaylock which requires additional pam settings
    self.programs.locker.swaylock.enable = true;

    user.packages = [ (pkgs.scripts.glitchlock.override { isWayland = true; }) ];
  };
}
