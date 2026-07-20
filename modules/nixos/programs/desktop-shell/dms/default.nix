# Dank Material Shell
{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  dprg = prg.default;
  isDefaultBar = dprg.statusBar.name == "dms";
in
{
  imports = [ sources.dms-plugin-registry.nixosModules.default ];

  config = mkIf prg.desktopShell.dms.enable {
    self.programs.default = {
      statusBar = mkIf isDefaultBar {
        toggle = "dms ipc bar toggle index 0";
      };
      locker = mkIf (dprg.locker.name == "dms") {
        cmd = "dms ipc lock lock";
      };
      powerMenu = mkIf (dprg.powerMenu.name == "dms") {
        cmd = "dms ipc powermenu toggle";
      };
    };

    programs.dms-shell = {
      enable = true;
      systemd.enable = isDefaultBar;
      plugins = {
        dankKDEConnect.enable = config.programs.kdeconnect.enable;
      };
    };
  };
}
