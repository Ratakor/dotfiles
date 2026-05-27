{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.programs.apps.discord;
  package = pkgs.discord;
in
{
  config = mkIf cfg.enable {
    self.programs.apps.discord.package = package;
    user.packages = [ package ];
  };
}
