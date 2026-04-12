# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.self.programs.menu;
in
{
  config = mkIf (cfg.program == "vicinae") {
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

    self.programs.menu = {
      dynamic = "vicinae dmenu";
      drun = "vicinae toggle";
      run = "vicinae toggle"; # no equivalent
    };
  };
}
