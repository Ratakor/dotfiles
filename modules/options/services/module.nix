{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.self.services = {
    librespot.enable = mkEnableOption "Librespot, Spotify playback daemon";
    udiskie.enable = mkEnableOption "udiskie, Removable disk automounter";
    syncthing.enable = mkEnableOption "Syncthing" // {
      default = true;
    };
  };
}
