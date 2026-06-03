# Based on https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/profiles/installation-device.nix
{
  config,
  lib,
  pkgs,
  sources,
  self,
  ...
}:
let
  inherit (lib.modules) mkImageMediaOverride;
  inherit (lib.sources) cleanSource;

  name = "${config.networking.hostName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
in
{
  imports = [
    # Provides options for modifying the ISO image
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/installer/cd-dvd/iso-image.nix
    "${sources.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    # Include a copy of Nixpkgs so that nixos-install works out of the box.
    "${sources.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  image.baseName = mkImageMediaOverride name;

  isoImage = {
    volumeID = mkImageMediaOverride name;
    makeBiosBootable = true;
    makeEfiBootable = true;
    makeUsbBootable = true;

    # Get rid of "installer" suffix in boot menu.
    appendToMenuLabel = "";

    contents = [
      {
        source = cleanSource self;
        target = "/root/self"; # maybe /self or /etc/nixos/flake instead?
      }
    ];
  };
}
