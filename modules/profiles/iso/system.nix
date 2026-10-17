{
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (lib.sources) cleanSource;
in
{
  system = {
    stateVersion = "25.05";

    # Make the image _immutable_ by removing the ability to use `nixos-rebuild switch`
    switch.enable = false;

    # To speed up installation a little bit, include the complete
    # stdenvNoCC in the Nix store on the CD.
    extraDependencies =
      with pkgs;
      [
        stdenvNoCC # for runCommand
        busybox
        # For boot.initrd.systemd
        makeInitrdNGTool
      ]
      ++ jq.all; # for closureInfo

    # isoImage.contents is relative to /iso and read-only so we're doing this instead.
    # This makes it so that this flake is available in ~/self as root which means
    # we can do `nixos-install --flake ~/self#HOST` to easily bootstrap NixOS.
    activationScripts.customFiles = {
      deps = [ "users" ];
      text = ''
        mkdir /mnt

        cp -r ${cleanSource self} /root/self
      '';
    };
  };
}
