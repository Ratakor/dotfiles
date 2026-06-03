# Based on https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/profiles/installation-device.nix
{
  config,
  lib,
  pkgs,
  sources,
  ...
}:
let
  inherit (builtins) concatStringsSep length;
  inherit (lib.modules) mkImageMediaOverride;
  inherit (lib.strings) optionalString;

  inherit (config.networking) hostName;
  inherit (config.system) nixos;
  inherit (pkgs.stdenv) hostPlatform;
in
{
  imports = [
    # Provides options for modifying the ISO image
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/installer/cd-dvd/iso-image.nix
    "${sources.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    # Include a copy of Nixpkgs so that nixos-install works out of the box.
    "${sources.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  image.baseName = mkImageMediaOverride "${hostName}-${nixos.label}-${hostPlatform.system}";

  isoImage = {
    volumeID = mkImageMediaOverride "${hostName}${
      optionalString (length nixos.tags > 0) "-${concatStringsSep "-" nixos.tags}"
    }-${nixos.release}-${hostPlatform.uname.processor}";
    makeBiosBootable = true;
    makeEfiBootable = true;
    makeUsbBootable = true;

    # Get rid of "installer" suffix in boot menu.
    appendToMenuLabel = "";
  };
}
