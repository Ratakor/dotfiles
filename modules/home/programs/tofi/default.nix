# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.generators) toINIWithGlobalSection;
  inherit (self.lib) wrapWith;

  colors = config.self.colors.default;

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

  tofi = wrapWith pkgs {
    basePackage = self.pkgs.tofi-dmenu;
    prependFlags = [
      "--config"
      (pkgs.writeText "tofi-config" (toINIWithGlobalSection { } { globalSection = settings; }))
    ];
  };
in
{
  config = mkIf (config.self.programs.menu.program == "tofi") {
    user.packages = [ tofi ];

    self.programs.menu = {
      dynamic = "tofi";
      drun = "exec $(tofi-drun)";
      run = "exec $(tofi-run)";
    };
  };
}
