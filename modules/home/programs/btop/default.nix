{
  pkgs,
  self,
  ...
}: let
  inherit (self.lib) wrapWith;

  btop = wrapWith pkgs {
    basePackage = pkgs.btop;
    prependFlags = ["--config" ./btop.config];
  };
in {
  user.packages = [btop];
}
