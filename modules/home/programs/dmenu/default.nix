# Dynamic Menu for X11
# TODO
{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (config.self.menu.program == "dmenu") {
    # user.packages = [dmenu];

    self.menu = {
      dynamic = "dmenu -i";
      drun = "dmenu_run"; # dmenu_run -hp 'chromium,...'
      run = "dmenu_run";
    };
  };
}
