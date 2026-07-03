{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf str;
in
{
  options.self.disabledPackages = mkOption {
    type = listOf str;
    default = [ ];
    example = [
      "vim"
      "git"
    ];
    description = ''
      List of package names to disable from pkgs.
    '';
  };
}
