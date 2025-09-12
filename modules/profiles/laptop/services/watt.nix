{
  self,
  pkgs,
  ...
}:
let
  module = import "${self.pins.watt}/nix/module.nix" { };
in
{
  imports = [ module ];

  services.watt = {
    enable = true;
    package = self.pkgs.watt; # thank you for being lazy mr nix
    # TODO
    settings = { };
  };
}
