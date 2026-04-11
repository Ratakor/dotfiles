{
  imports = [
    ./login.nix
    ./openssh.nix
  ];

  services = {
    # enable NTP client to sync time
    ntp.enable = true;

    # TODO: is userborn useful?
    userborn.enable = false;
  };
}
