{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.self.system.security.fprint = {
    enable = mkEnableOption "Fingerprint reader service";
  };
}
