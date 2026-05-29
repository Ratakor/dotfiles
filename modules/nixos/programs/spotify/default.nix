{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.programs.apps.spotify;
  package = pkgs.spotify;
in
{
  config = mkIf cfg.enable {
    self.programs.apps.spotify.package = package;
    user.packages = [ package ];
  };
}
