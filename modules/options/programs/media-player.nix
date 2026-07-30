{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram;
in
mkVideoProgram config "media player" {
  values = [
    "mpv"
    "vlc"
  ];
  default = "mpv";
  hasPackage = true;
}
