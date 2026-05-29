{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  package = pkgs.vlc;
in
{
  config = mkIf prg.mediaPlayer.vlc.enable {
    self.programs.default.mediaPlayer = mkIf (prg.default.mediaPlayer.name == "vlc") {
      inherit package;
    };

    user.packages = [ package ];
  };
}
