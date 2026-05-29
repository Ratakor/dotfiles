# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  pkgs,
  ...
}:
let
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
      dmenu = "fuzzel --dmenu";
      drun = "fuzzel";
      run = "fuzzel --list-executables-in-path";
    };

    user.packages = [ package ];
  };
}
