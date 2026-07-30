{ config, lib, ... }:
let
  inherit (lib.options) mkVideoProgram mkEnableOption;
in
mkVideoProgram config "email client" {
  values = [
    "thunderbird"
  ];
  default = "thunderbird";
  optionPath = [ "email" ];
  hasPackage = true;
  extraOptions = {
    thunderbird = {
      dove = mkEnableOption "privacy and security hardening Thunderbird using the Dove config" // {
        default = true;
      };
    };
  };
}
