{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  package = pkgs.imv;
in
{
  config = mkIf prg.imageViewer.imv.enable {
    self.programs.default.imageViewer = mkIf (prg.default.imageViewer.name == "imv") {
      inherit package;
    };

    user.packages = [ package ];

    hj.xdg.config.files."imv/config" = {
      generator = lib.generators.toINI { };
      value.binds = {
        n = "next";
        p = "prev";
        "<Ctrl+p>" = "exec echo $imv_current_file";
      };
    };
  };
}
