# Interactive file-and-replace on files
{ config, self, ... }:
let
  scooter = self.pkgs.scooter-wrapped.override {
    inherit (config.self.colors.default.scooter) theme;
  };
in
{
  user.packages = [ scooter ];
}
