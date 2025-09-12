# Dynamic Menu for X11
{
  config,
  lib,
  self,
  ...
}:
let
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf;

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
  config = mkIf (config.self.menu.program == "dmenu") {
    user.packages = [ self.pkgs.suckless ];

    self.menu = {
      dynamic = "dmenu -i";
      drun = "dmenu_run -hp '${highPriority}";
      run = "dmenu_run";
    };
  };
}
