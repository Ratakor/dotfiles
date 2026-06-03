{ config, ... }:
let
  inherit (builtins) substring hashString;
in
{
  networking = {
    networkmanager.enable = true;

    # needed by ZFS, also need to be unique among all hosts
    hostId = substring 0 8 (hashString "md5" config.networking.hostName);
  };
}
