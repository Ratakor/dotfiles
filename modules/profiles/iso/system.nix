{ pkgs, ... }:
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
  };
}
