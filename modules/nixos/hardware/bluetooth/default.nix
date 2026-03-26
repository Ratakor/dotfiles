{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.hardware.bluetooth.enable) {
    hardware.bluetooth = {
      powerOnBoot = true;
      # https://github.com/bluez/bluez/blob/master/src/main.conf
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };
}
