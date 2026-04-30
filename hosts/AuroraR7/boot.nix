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
    kernelParams = [
      "nohibernate"
    ];
    # # I used to `modprobe dell-smm-hwmon ignore_dmi=1`
    # # but it seems to work (`sensors`) without it so idk
    # extraModeprobeConfig = ''
    #   options dell-smm-hwmon ignore_dmi=1
    # '';
  };
}
