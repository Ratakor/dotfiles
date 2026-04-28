{ lib, ... }:
{
  imports =
    map lib.listFilesRecursive [
      ./audio
      ./bluetooth
      ./cpu
      ./gpu
      ./video
    ]
    |> builtins.concatLists;

  # Enable firmware with a license allowing redistribution.
  # This is usually set by `nixos/modules/installer/scan/not-detected.nix`.
  hardware.enableRedistributableFirmware = true;
}
