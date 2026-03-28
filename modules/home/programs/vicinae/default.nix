# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.self.menu.program == "vicinae") {
    hm.programs.vicinae = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme = {
          # TODO: use config.self.colors
          light.name = "gruvbox-light";
          dark.name = "gruvbox-dark";
        };
        # TODO: rest of config
      };
    };

    self.menu = {
      dynamic = "vicinae dmenu";
      drun = "vicinae toggle";
      run = "vicinae toggle"; # no equivalent
    };
  };
}
