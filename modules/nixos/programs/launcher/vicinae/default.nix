# App Launcher / Dynamic Menu for Wayland
{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.self) colors;

  prg = config.self.programs;
in
{
  config = mkIf prg.launcher.vicinae.enable {
    self.programs.default.launcher = mkIf (prg.default.launcher.name == "vicinae") {
      dmenu = "vicinae dmenu";
      drun = "vicinae toggle";
      run = "vicinae toggle"; # no equivalent
      emoji = "vicinae vicinae://launch/core/search-emojis"; # idk but it works
    };

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
  };
}
