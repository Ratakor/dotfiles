# currently only used for nautilus file manager
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
  config = mkIf prg.fileManager.nautilus.enable {
    self.programs.default.fileManager = mkIf (prg.default.fileManager.name == "nautilus") {
      desktopEntry = "org.gnome.Nautilus.desktop";
    };

    user.packages = [ pkgs.nautilus ];
  };
}
