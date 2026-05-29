# Document Viewer
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
in
{
  config = mkIf prg.documentViewer.zathura.enable {
    self.programs.default.documentViewer = mkIf (prg.default.documentViewer.name == "zathura") {
      inherit (config.hm.programs.zathura) package;
    };

    hm.programs.zathura = {
      enable = true;
      options = {
        statusbar-h-padding = 0;
        statusbar-v-padding = 0;
        page-padding = 1;
        selection-clipboard = "clipboard";
        window-title-basename = true;
        statusbar-basename = true;
      };
      mappings = {
        i = "recolor";
        p = "print";
        w = "adjust_window width";
        W = "adjust_window best-fit";
      };
    };
  };
}
