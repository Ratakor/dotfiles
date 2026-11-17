{
  config,
  lib,
  sources,
  ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  dprg = prg.default;
in
{
  config = mkIf prg.fileManager.luciole.enable {
    self.programs.default.fileManager = mkIf (dprg.fileManager.name == "luciole") {
      desktopEntry = "dev.noctalia.luciole.desktop";
    };

    hm.imports = [ sources.luciole.homeModules.default ];

    hm.programs.luciole = {
      enable = true;

      # this is overridable via GUI
      # i love noctalia devs
      settings = {
        browser = {
          background_opacity = 0.8; # same as ghostty even tho 0.7 is kinda better
        };
      };
    };
  };
}
