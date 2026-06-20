{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    # Enable fan sensors
    kernelModules = [
      "dell-smm-hwmon"
    ];

    # Forces the fan sensors driver to load on unknown hardware
    extraModprobeConfig = ''
      options dell-smm-hwmon ignore_dmi=1
    '';

    blacklistedKernelModules = [
      "ath10k_pci" # wifi driver, the hardware seems faulty (several desktop crashes)
    ];
  };
}
