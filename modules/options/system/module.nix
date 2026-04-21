{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.lists) singleton;

  cfg = config.self.system;
in
{
  options.self.system = {
    audio.enable = mkEnableOption "audio drivers and related programs";

    video = {
      enable = mkEnableOption "video drivers and related programs";
      nvidia.enable = mkEnableOption "nvidia drivers and related programs";
    };

    bluetooth.enable = mkEnableOption "bluetooth drivers and related programs";

    # .enable is too verbose for this
    displayServer = {
      wayland = mkEnableOption "Wayland display server";
      x11 = mkEnableOption "X11 display server";
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.displayServer.wayland && cfg.displayServer.x11);
        message = "You cannot enable both Wayland and X11 display servers simultaneously.";
      }
    ];

    system.nixos.tags =
      if cfg.displayServer.wayland then
        singleton "wayland"
      else if cfg.displayServer.x11 then
        singleton "x11"
      else
        [ ];
  };
}
