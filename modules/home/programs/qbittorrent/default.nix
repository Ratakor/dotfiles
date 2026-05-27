{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.programs.apps.qbittorrent;
  package = pkgs.qbittorrent;
in
{
  config = mkIf cfg.enable {
    self.programs.apps.qbittorrent.package = package;
    user.packages = [ package ];
  };
}
