{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.lists) singleton;

  cfg = config.self.system.displayServer;
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
