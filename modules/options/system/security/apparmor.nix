{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.self.system.security.apparmor = {
    enable = mkEnableOption "AppArmor";
  };
}
