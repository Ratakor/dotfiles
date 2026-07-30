{ config, lib, ... }:
let
  inherit (lib.options) mkProgram;
in
mkProgram config "image editor" {
  values = [
    "aseprite" # pixel art editor
    "drawy"
    "gimp"
    "krita"
    "pinta"
  ];
  nullable = true;
}
