{ config, ... }:
let
  cfg = config.self.system.virt;
in
{
  imports = [
    ./distrobox.nix
    ./podman.nix
  ];

  virtualisation = {
    # TODO: qemu
    libvirtd = {
      enable = false;
    };

    waydroid.enable = cfg.waydroid.enable;
  };
}
