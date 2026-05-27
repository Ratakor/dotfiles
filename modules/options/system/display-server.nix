{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.lists) singleton;

  sys = config.self.system;
  cfg = sys.displayServer;
in
{
  # .enable is too verbose for this
  options.self.system.displayServer = {
    wayland = mkEnableOption "Wayland display server";
    x11 = mkEnableOption "X11 display server";
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.wayland && cfg.x11);
        message = "You cannot enable both Wayland and X11 display servers simultaneously.";
      }
      {
        # we could instead use == instead of -> to enforce a display server when video is enabled
        assertion = (cfg.wayland || cfg.x11) -> sys.video.enable;
        message = "Display server requires config.self.video to be enabled.";
      }
    ];

    system.nixos.tags =
      if cfg.wayland then
        singleton "wayland"
      else if cfg.x11 then
        singleton "x11"
      else
        [ ];
  };
}
