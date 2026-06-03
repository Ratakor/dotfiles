{ config, lib, ... }:
let
  inherit (lib.modules) mkForce;
  inherit (lib.strings) optionalString;
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
}
