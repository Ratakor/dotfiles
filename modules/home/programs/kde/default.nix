# currently only used for dolphin file manager
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
in
{
  config = mkIf prg.fileManager.dolphin.enable {
    self.programs.default.fileManager = mkIf (prg.default.fileManager.name == "dolphin") {
      desktopEntry = "org.kde.dolphin.desktop";
    };

    user.packages = [ pkgs.kdePackages.dolphin ];
  };
}
