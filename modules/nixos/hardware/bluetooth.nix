{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.system.bluetooth;
in
{
  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
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
