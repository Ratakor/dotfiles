{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.programs.apps.discord;
in
{
  config = mkIf cfg.enable {
    user.packages = [ cfg.package ];
  };
}
