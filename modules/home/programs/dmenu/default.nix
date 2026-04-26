# Dynamic Menu for X11
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf;

  prg = config.self.programs;

  highPriority = concatStringsSep "," [
    "chromium"
    "thunderbird"
    "lutris"
    "discord"
    "anki"
    "steam"
    "monero-wallet-gui"
  ];
in
{
  config = mkIf prg.launcher.dmenu.enable {
    self.programs.default.launcher = mkIf (prg.default.launcher.name == "dmenu") {
      dmenu = "dmenu -i";
      drun = "dmenu_run -hp '${highPriority}'";
      run = "dmenu_run";
    };

    user.packages = [ pkgs.suckless ];
  };
}
