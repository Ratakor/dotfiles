# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  package = pkgs.wrappers.tofi.override {
    inherit (config.self) colors;
  };
in
{
  config = mkIf prg.launcher.tofi.enable {
    self.programs.default.launcher = mkIf (prg.default.launcher.name == "tofi") {
      dmenu = "tofi";
      drun = "exec $(tofi-drun)";
      run = "exec $(tofi-run)";
      emoji = getExe (
        pkgs.emojisearch.override {
          dmenuCommand = "tofi"; # --num-results=10
          copyCommand = "wl-copy";
        }
      );
    };

    user.packages = [ package ];
  };
}
