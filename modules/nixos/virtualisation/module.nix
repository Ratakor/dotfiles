{ config, ... }:
let
  cfg = config.self.system.virt;
in
{
  imports = [
    ./distrobox.nix
    ./podman.nix
    ./qemu.nix
  ];

  virtualisation = {
    waydroid.enable = cfg.waydroid.enable;
  };
}
