{ lib, pkgs, ... }:
let
  inherit (lib.options) mkPackageOption mkEnableOption;
in
{
  options.self.system.virt = {
    podman.enable = mkEnableOption "Podman with Docker support";
    qemu = {
      enable = mkEnableOption "QEMU";
      package = mkPackageOption pkgs "qemu" {
        default = "qemu_kvm";
      };
    };
    waydroid.enable = mkEnableOption "Waydroid";
    distrobox = {
      enable = mkEnableOption "Distrobox";
      autoUpgrade.enable = mkEnableOption "periodically upgrade all distrobox containers";
    };
  };
}
