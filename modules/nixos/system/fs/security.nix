# https://wiki.archlinux.org/title/Security#Mount_options
{ lib, ... }:
let
  inherit (lib.attrsets) genAttrs;
in
{
  fileSystems =
    genAttrs
      [
        # "/var"
        # "/var/log"
        # "/home" # shouldn't have noexec
        # "/dev/shm"
        # "/tmp" # shouldn't have noexec
        "/boot"
      ]
      (_name: {
        options = [
          "nodev"
          "nosuid"
          "noexec"
        ];
      });
}
