{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.system.boot.loader;
in
{
  config = mkIf cfg.systemd-boot.enable {
    boot.loader.systemd-boot = {
      enable = true;
      inherit (cfg) configurationLimit;
      # Default is true but it's recommended to set it to false as it's a
      # security hole that could allow gaining root access by passing init=/bin/sh
      editor = false;
    };
  };
}
