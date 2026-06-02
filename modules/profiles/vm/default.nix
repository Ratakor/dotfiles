# -device virtio-vga-gl -display gtk,gl=on
# TODO: mouse pointer doesn't work when input is captured
{ lib, modulesPath, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    spice-webdavd.enable = true;
  };

  virtualisation.vmVariant.virtualisation = {
    memorySize = 8 * 1024; # 8GiB
    cores = 8;
  };

  self = {
    device.monitors = mkForce [ ];
    system.fs.btrfs.autoSnapshot.subvolumes = mkForce { };
  };
}
