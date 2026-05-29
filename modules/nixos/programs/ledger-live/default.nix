# Ledger cryptocurrency hardware wallet
# see monero-gui in packages/graphical.nix too
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf false {
    user.packages = with pkgs; [
      ledger-live-desktop
      ledger-udev-rules # should this be system?
    ];
  };
}
