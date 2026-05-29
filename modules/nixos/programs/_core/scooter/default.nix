# Interactive file-and-replace on files
{ config, pkgs, ... }:
let
  scooter = pkgs.wrappers.scooter.override {
    inherit (config.self.colors.default.scooter) theme;
  };
in
{
  user.packages = [ scooter ];
}
