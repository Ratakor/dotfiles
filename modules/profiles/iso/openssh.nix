{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };

  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];
}
