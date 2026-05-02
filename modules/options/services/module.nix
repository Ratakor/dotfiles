{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  cfg = config.self.services;
  sys = config.self.system;
in
{
  options.self.services = {
    kanshi.enable = mkEnableOption "Kanshi";
    librespot.enable = mkEnableOption "Librespot";
    wpaperd.enable = mkEnableOption "wpaperd" // {
      default = sys.displayServer.wayland;
    };
  };
}
