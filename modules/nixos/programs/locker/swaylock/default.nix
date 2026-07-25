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
  config = mkIf prg.locker.swaylock.enable {
    self.programs.default.locker = mkIf (prg.default.locker.name == "swaylock") {
      cmd = "swaylock";
    };

    # This must be set even if empty to make swaylock work
    security.pam.services.swaylock = {
      fprintAuth = config.services.fprintd.enable;
    };

    user.packages = [ pkgs.swaylock ];
  };
}
