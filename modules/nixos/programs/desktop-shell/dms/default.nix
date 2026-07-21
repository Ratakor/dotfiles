# Dank Material Shell
{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  defaultName = "dms";

  prg = config.self.programs;
  dprg = prg.default;
  isDefaultBar = dprg.statusBar.name == defaultName;
  isDefaultLauncher = dprg.launcher.name == defaultName;
in
{
  imports = [ sources.dms-plugin-registry.nixosModules.default ];

  config = mkIf prg.desktopShell.dms.enable {
    self.programs.default = {
      statusBar = mkIf isDefaultBar {
        toggle = "dms ipc call bar toggle index 0";
      };
      locker = mkIf (dprg.locker.name == defaultName) {
        cmd = "dms ipc call lock lock";
      };
      powerMenu = mkIf (dprg.powerMenu.name == defaultName) {
        cmd = "dms ipc call powermenu toggle";
      };
      launcher = mkIf isDefaultLauncher {
        dmenu = "fuzzel --dmenu";
        drun = "dms ipc call spotlight toggle";
        run = "dms ipc call spotlight toggleQuery '>'";
      };
    };

    # fuzzel is used as a fallback launcher for dmenu mode
    self.programs.launcher.fuzzel.enable = isDefaultLauncher;

    programs.dms-shell = {
      enable = true;
      systemd.enable = isDefaultBar;

      # TODO: settings
      # handle `dprg.notification.name == defaultName` in settings

      plugins = {
        dankKDEConnect.enable = config.programs.kdeconnect.enable;
        nixPackageRunner.enable = false; # too slow
        commandRunner.enable = true; # used for launcher run
        # emojiLauncher.enable = true;
        # calculator.enable = true;
      };
    };
  };
}
