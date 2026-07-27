{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  # I don't like this
  options.self.programs.dev = {
    enable = mkEnableOption "development related packages";
  };
}
