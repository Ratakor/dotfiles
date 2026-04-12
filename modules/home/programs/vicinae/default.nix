# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.self) colors;

  cfg = config.self.programs.menu;
in
{
  config = mkIf (cfg.program == "vicinae") {
    hm.programs.vicinae = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme = {
          light.name = colors.light.vicinae.theme;
          dark.name = colors.dark.vicinae.theme;
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
