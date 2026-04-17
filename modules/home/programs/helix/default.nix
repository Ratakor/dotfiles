{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib.modules) mkIf;

  package = self.pkgs.helix-wrapped.override {
    inherit (config.self.colors.default.helix) theme;
  };
in
{
  config = mkIf (config.self.programs.editor.program == "helix") {
    self.programs.editor = {
      cmd = "hx";
      desktopEntry = "Helix.desktop";
    };

    user.packages = [ package ];
  };
}
