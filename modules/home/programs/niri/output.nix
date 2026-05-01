# https://yalter.github.io/niri/Configuration:-Outputs
{ config, lib }:
let
  inherit (lib) optionalString;

  transform = [
    "normal"
    "90"
    "180"
    "270"
    "flipped"
    "flipped-90"
    "flipped-180"
    "flipped-270"
  ];
in
config.self.device.monitors
|> lib.imap0 (
  i: m:
  # kdl
  ''
    output "${m.name}" {
      ${optionalString (!m.enable) "off"}
      mode "${toString m.width}x${toString m.height}${
        optionalString (m.refreshRate != null) "@${toString m.refreshRate}"
      }"
      scale ${toString m.scale}
      transform "${builtins.elemAt transform m.transform}"
      position x=${toString m.x} y=${toString m.y}
      ${optionalString m.variableRefreshRate "variable-refresh-rate on-demand=true"}
      ${optionalString (i == 0) "focus-at-startup"}
    }
  ''
)
|> builtins.concatStringsSep "\n"
