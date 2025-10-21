{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.imageViewer.program == "imv") {
    hm.programs.imv = {
      enable = true;
      settings.binds = {
        n = "next";
        p = "prev";
        "<Ctrl+p>" = "exec echo $imv_current_file";
      };
    };

    self.imageViewer = {
      cmd = "imv";
      desktopEntry = "imv.desktop";
    };
  };
}
