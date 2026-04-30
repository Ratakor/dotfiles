{
  boot = {
    initrd.availableKernelModules = [
      "uhci_hcd"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
    ];
    loader.grub.default = 1; # can't boot on index 0 smh
  };
}
