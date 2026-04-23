{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;
in
{
  options.self = {
    username = mkOption {
      type = str;
      description = "Username of the main user.";
      default = "ratakor";
    };

    docs.enable = mkEnableOption "generation of internal module documentation to `/etc/nixos/docs`";
  };
}
