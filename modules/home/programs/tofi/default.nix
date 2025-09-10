# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.generators) toINIWithGlobalSection;
  inherit (self.lib) wrapWith;
  inherit (config.self) colors;

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
    basePackage = pkgs.tofi-dmenu;
    prependFlags = [
      "--config"
      (pkgs.writeText "tofi-config" (toINIWithGlobalSection {} {globalSection = settings;}))
    ];
  };
in {
  config = mkIf (false && config.self.displayServer == "wayland") {
    user.packages = [tofi];

    self.menu = {
      dynamic = "tofi";
      drun = "exec $(tofi-drun)";
      run = "exec $(tofi-run)";
    };
  };
}
