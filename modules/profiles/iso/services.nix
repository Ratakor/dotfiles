{ config, lib, ... }:
let
  inherit (lib.modules) mkForce;
  inherit (lib.strings) optionalString;
in
{
  services = {
    getty = {
      autologinUser = "root";

      helpLine = ''
        The "nixos" and "root" accounts have empty passwords.

        To log in over ssh you must set a password for either "nixos" or "root"
        with `passwd` (prefix with `sudo` for "root"), or add your public key to
        /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys.

        To set up a wireless connection, run `nmtui`.
      ''
      + optionalString config.services.xserver.enable ''

        Type `sudo systemctl start display-manager' to
        start the graphical user interface.
      '';
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
      };
    };

    logrotate.enable = false;
  };

  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];
}
