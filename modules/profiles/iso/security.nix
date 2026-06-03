{ lib, ... }:
let
  inherit (lib.modules) mkImageMediaOverride;
in
{
  security = {
    # Don't require sudo/root to `reboot` or `poweroff`.
    polkit.enable = true;

    sudo = {
      enable = true;
      wheelNeedsPassword = mkImageMediaOverride false;
    };
  };
}
