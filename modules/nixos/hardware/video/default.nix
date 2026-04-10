{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (self.lib.trivial) isx86Linux;

  cfg = config.self.system.video;
in
{
  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = isx86Linux pkgs;
    };

    # Enable the X11 windowing system (still needed for wayland iirc)
    services.xserver.enable = true;
  };
}
