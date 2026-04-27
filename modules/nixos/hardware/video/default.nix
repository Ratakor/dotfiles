{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.trivial) isx86Linux;

  cfg = config.self.system.video;
in
{
  imports = [
    ./nvidia.nix
  ];

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = isx86Linux pkgs;
    };
  };
}
