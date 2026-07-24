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
  isDefaultWallpaper = dprg.wallpaper.name == defaultName;
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
        cmd = "dms ipc call spotlight toggle";
        emoji = "dms ipc call spotlight toggleQuery ':e '";
      };
      wallpaper = mkIf isDefaultWallpaper {
        nextRandom = "dms ipc call wallpaper next";
        set = "dms ipc call wallpaper set";
      };
    };

    programs.dms-shell = {
      enable = true;
      systemd.enable = isDefaultBar;

      # TODO: settings
      # handle `dprg.notification.name == defaultName` in settings
      # handle isDefaultWallpaper in settings

      plugins = {
        dankKDEConnect.enable = config.programs.kdeconnect.enable;
        nixPackageRunner.enable = false; # too slow
        # commandRunner.enable = true; # previously used for launcher run
        emojiLauncher.enable = true; # used for launcher emoji
        # calculator.enable = true;
      };
    };
  };
}
