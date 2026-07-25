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

  package = pkgs.wrappers.fuzzel.override {
    inherit (config.self) colors;
    inherit (prg.terminal) fontSize;
  };
in
{
  config = mkIf prg.launcher.fuzzel.enable {
    self.programs.default.launcher = mkIf (prg.default.launcher.name == "fuzzel") {
      cmd = "fuzzel";
      emoji = getExe (
        pkgs.scripts.emojisearch.override {
          dmenuCommand = "fuzzel --dmenu -l 30";
          copyCommand = "wl-copy";
        }
      );
    };

    user.packages = [ package ];
  };
}
