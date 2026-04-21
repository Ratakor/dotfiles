{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  cfg = config.self.programs.gaming;
in
{
  options.self.programs.gaming = {
    enable = mkEnableOption "gaming related packages";
    star-citizen.enable = mkEnableOption "Star Citizen specific packages";
    wow.enable = mkEnableOption "World of Warcraft specific packages";
    poe.enable = mkEnableOption "Path of Exile specific packages";
    steam.enable = mkEnableOption "Steam" // {
      default = cfg.enable;
    };
    lutris.enable = mkEnableOption "Lutris";
  };
}
