{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  sys = config.self.system;
  cfg = sys.login;
in
{
  services.displayManager.gdm = mkIf (cfg.manager == "gdm") {
    enable = true;
    inherit (sys.displayServer) wayland;
    # settings = {};
  };
}
