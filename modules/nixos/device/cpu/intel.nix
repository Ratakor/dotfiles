{ config, lib, ... }:
let
  dev = config.self.device;
in
{
  config = lib.mkIf (dev.cpu.type == "intel") {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = [ "kvm-intel" ];
    };
  };
}
