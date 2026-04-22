# TODO: use config.self.system.virt
{
  imports = [
    ./podman.nix
  ];

  virtualisation = {
    # TODO: qemu
    libvirtd = {
      enable = false;
    };

    # TODO
    # Container-based approach to boot a full Android system on a regular GNU/Linux system
    waydroid.enable = false;
  };

  # TODO: distrobox
}
