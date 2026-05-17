{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  dprg = config.self.programs.default;
  cfg = config.self.system.login;
in
{
  services.displayManager.dms-greeter = mkIf (cfg.manager == "dms-greeter") {
    enable = true;
    configHome = config.user.home;
    compositor.name = dprg.windowManager.name;
  };
}
