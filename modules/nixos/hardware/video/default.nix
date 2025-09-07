{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (self.lib.trivial) isx86Linux;
in {
  # TODO: only enable if system is graphics capable
  config = mkIf true {
    hardware.graphics = {
      enable = true;
      enable32Bit = isx86Linux pkgs;
    };
  };
}
