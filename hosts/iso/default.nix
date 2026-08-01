{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib.modules) mkForce;
  inherit (lib.strings) optionalString;

  colors = import (self + /modules/options/misc/colors) { };
in
{
  networking.hostName = mkForce "nixos";

  services.getty = {
    autologinUser = "root";

    helpLine = ''
      The "nixos" and "root" accounts have empty passwords.

      To log in over ssh you must set add your public key to
      /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys.

      A nixos configuration is provided at /root/self.

      To set up a wireless connection, run `nmtui`.
    ''
    + optionalString config.services.xserver.enable ''

      Type `sudo systemctl start display-manager' to
      start the graphical user interface.
    '';
  };

  console.colors = with colors.default; [
    black
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    bright.black
    bright.red
    bright.green
    bright.yellow
    bright.blue
    bright.magenta
    bright.cyan
    bright.white
  ];
}
