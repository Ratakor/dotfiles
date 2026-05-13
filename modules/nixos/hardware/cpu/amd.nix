{ config, lib, ... }:
let
  dev = config.self.device;
in
{
  config = lib.mkIf (dev.cpu.type == "amd") {
    hardware.cpu.amd.updateMicrocode = true;
    boot = {
      kernelModules = [ "kvm-amd" ];
    };
  };
}
