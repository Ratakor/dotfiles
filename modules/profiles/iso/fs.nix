{ config, lib, ... }:
let
  inherit (lib.modules) mkImageMediaOverride;
in
{
  # An installation media cannot tolerate a host config defined file
  # system layout on a fresh machine, before it has been formatted.
  swapDevices = mkImageMediaOverride [ ];
  fileSystems = mkImageMediaOverride config.lib.isoFileSystems;
  boot.initrd.luks.devices = mkImageMediaOverride { };

  # Prevent installation media from evacuating persistent storage, as their
  # var directory is not persistent and it would thus result in deletion of
  # those entries.
  # See: pstore.conf(5)
  environment.etc."systemd/pstore.conf".text = ''
    [PStore]
    Unlink=no
  '';
}
