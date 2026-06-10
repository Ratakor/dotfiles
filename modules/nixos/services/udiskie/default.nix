# USB device manager (auto-mounting)
{ config, lib, ... }:
let
  dprg = config.self.programs.default;
  cfg = config.self.services.udiskie;
in
{
  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;

    hm.services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
      settings = {
        program_options = {
          terminal = dprg.terminal.cmdDir;
        };
      };
    };
  };
}
