# https://yalter.github.io/niri/Configuration:-Outputs
{ config, lib }:
let
  inherit (lib) optionalString;
in
config.self.device.monitors
|> map (m: /* kdl */ ''
  output "${m.name}" {
    ${optionalString (!m.enable) "off"}
    mode "${toString m.width}x${toString m.height}${
      optionalString (m.refreshRate != null) "@${toString m.refreshRate}"
    }"
    scale ${toString m.scale}
    // TODO: transform
    position x=${toString m.x} y=${toString m.y}
    ${optionalString m.variableRefreshRate "variable-refresh-rate on-demand=true"}
  }
'')
|> builtins.concatStringsSep "\n"
