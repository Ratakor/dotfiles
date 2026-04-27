{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  cfg = config.self.services;
in
{
  options.self.services = {
    kanshi.enable = mkEnableOption "Kanshi";
    librespot.enable = mkEnableOption "Librespot";
  };
}
