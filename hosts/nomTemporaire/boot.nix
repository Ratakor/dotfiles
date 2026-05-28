{
  boot = {
    initrd = {
      luks.devices."enc".device = "/dev/disk/by-uuid/c3939500-2ba1-4a25-a815-f2a5c1ee8d8b";

      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
    };
  };
}
