{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  options.self.programs.dev = {
    enable = mkEnableOption "development related packages";
  };
}
