{ config, ... }:
{
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    open = false;
    powerManagement.enable = false; # not supported
  };
}
