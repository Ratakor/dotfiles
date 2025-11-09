# Interactive file-and-replace on files
{ config, self, ... }:
let
  scooter = self.pkgs.scooter-wrapped.override {
    theme = config.self.colorscheme;
  };
in
{
  user.packages = [ scooter ];
}
