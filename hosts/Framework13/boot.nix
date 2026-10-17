{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "uas"
      # "usb_storage"
      "sd_mod"
    ];
  };
}
