{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum str nullOr;

  cfg = config.self.programs;
  sys = config.self.system;
in
{
  options.self.programs = {
    windowManager = mkOption {
      type = nullOr (enum [
        "dwm"
        "hyprland"
        "niri"
        "river" # not implemented
        "river-classic"
      ]);
      default = if sys.displayServer == "wayland" then "niri" else "dwm";
      description = "The window manager to use.";
    };
  };
}
