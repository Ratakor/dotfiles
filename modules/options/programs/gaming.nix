{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  mkEnableOption' = desc: mkEnableOption desc // { default = true; };

  cfg = config.self.programs.gaming;
in
{
  options.self.programs.gaming = {
    enable = mkEnableOption "gaming related packages";

    steam.enable = mkEnableOption' "Steam";

    star-citizen.enable = mkEnableOption "Star Citizen specific packages";
    wow.enable = mkEnableOption "World of Warcraft specific packages";
    poe.enable = mkEnableOption "Path of Exile specific packages";
    minecraft.enable = mkEnableOption "Minecraft specific packages";
    osu.enable = mkEnableOption "osu! specific packages";
    lutris.enable = mkEnableOption "Lutris";
  };
}
