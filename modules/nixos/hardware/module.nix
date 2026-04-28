{
  imports = [
    ./audio
    ./bluetooth.nix
    ./cpu
    ./fs
    ./gpu
    ./video
  ];

  # Enable firmware with a license allowing redistribution.
  # This is usually set by `nixos/modules/installer/scan/not-detected.nix`.
  hardware.enableRedistributableFirmware = true;
}
