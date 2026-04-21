# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  pkgs,
  self,
  wlib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.trivial) const;

  colors = config.self.colors.default;
  prg = config.self.programs;

  package = wlib.evalPackage (const {
    inherit pkgs;
    imports = [ wlib.wrapperModules.tofi ];
    package = self.pkgs.tofi-dmenu;
    settings = {
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "33%";
      padding-top = "33%";
      result-spacing = 5;
      num-results = 10;
      font = "monospace";
      require-match = false;
      background-color = colors.background + "d9"; # "#000a";
      text-color = colors.foreground;
      selection-color = colors.cyan;
    };
  });
in
{
  config = mkIf prg.launcher.tofi.enable {
    self.programs.default.launcher = mkIf (prg.default.launcher.name == "tofi") {
      dmenu = "tofi";
      drun = "exec $(tofi-drun)";
      run = "exec $(tofi-run)";
    };

    user.packages = [ package ];
  };
}
