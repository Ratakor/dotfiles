{ config, ... }:
let
  cfg = config.self.system.virt.waydroid;
in
{
  virtualisation.waydroid.enable = cfg.enable;
}
