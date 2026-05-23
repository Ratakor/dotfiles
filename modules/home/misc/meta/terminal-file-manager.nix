{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;

  prg = config.self.programs;
  dprg = prg.default;
in
{
  config = mkIf prg.fileManager.terminal.enable {
    self.programs.default.fileManager = mkIf (prg.default.fileManager.name == "terminal") {
      desktopEntry = "terminal-directory.desktop";
    };

    hm.xdg.desktopEntries.terminal-directory = {
      name = "Directory (${dprg.terminal.name})";
      exec = "${dprg.terminal.cmdDir} %f";
      icon = dprg.terminal.name; # hopefully it's right one
    };
  };
}
