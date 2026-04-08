{
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkEnableOption;

  cfg = config.self.system;
in
{
  options.self.system = {
    audio.enable = mkEnableOption "audio drivers and related programs";

    video = {
      enable = mkEnableOption "video drivers and related programs";
      # TODO: nvidia
    };

    bluetooth.enable = mkEnableOption "bluetooth drivers and related programs";
  };
}
