# Hardware configuration of the device
{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib) types;
in
{
  # should this be renamed hardware instead of device?
  # or merge with system
  # or split system into multiple modules
  # idk, it doesn't matter much anyway
  options.self.device = {
    cpu = {
      type = mkOption {
        type = types.enum [ "intel" ];
        description = "The manufacturer of the primary system CPU.";
      };
    };

    gpu = {
      type = mkOption {
        type = types.nullOr (types.enum [ "nvidia" ]);
        default = null;
        description = "The manufacturer of the primary system GPU.";
      };
    };
  };
}
