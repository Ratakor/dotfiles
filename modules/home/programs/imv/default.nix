{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
in
{
  config = mkIf prg.imageViewer.imv.enable {
    self.programs.default.imageViewer = mkIf (prg.default.imageViewer.name == "imv") {
      inherit (config.hm.programs.imv) package;
    };

    hm.programs.imv = {
      enable = true;
      settings.binds = {
        n = "next";
        p = "prev";
        "<Ctrl+p>" = "exec echo $imv_current_file";
      };
    };
  };
}
