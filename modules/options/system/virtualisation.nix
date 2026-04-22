{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.self.system.virt = {
    podman.enable = mkEnableOption "Podman with Docker support";
    qemu.enable = mkEnableOption "QEMU";
    waydroid.enable = mkEnableOption "Waydroid";
    distrobox = {
      enable = mkEnableOption "Distrobox";
      autoUpgrade.enable = mkEnableOption "periodically upgrade all distrobox containers";
    };
  };
}
