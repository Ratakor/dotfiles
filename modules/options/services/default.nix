{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  mkEnableOption' = desc: mkEnableOption desc // { default = true; };
in
{
  options.self.services = {
    udiskie.enable = mkEnableOption' "udiskie, Removable disk automounter";
    syncthing.enable = mkEnableOption' "Syncthing";

    librespot.enable = mkEnableOption "Librespot, Spotify playback daemon";
  };
}
