{ lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str int;
in
{
  options.self = {
    username = mkOption {
      type = str;
      description = "Username of the main user.";
      default = "ratakor";
    };

    fontSize = mkOption {
      type = int;
      default = 10;
      description = "Font size, mainly used by terminal emulator.";
    };

    docs.enable = mkEnableOption "generation of internal module documentation to `/etc/nixos/docs`";
  };
}
