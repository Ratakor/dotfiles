# -device virtio-vga-gl -display gtk,gl=on
# TODO: mouse pointer doesn't work when input is captured
{
  lib,
  modulesPath,
  self,
  ...
}:
let
  inherit (lib.modules) mkVMOverride;
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

  environment.etc."nixos/flake".source = self;

  self = {
    device.monitors = mkVMOverride [ ];
    system.fs.btrfs.autoSnapshot.subvolumes = mkVMOverride { };
  };
}
