# Terminal multiplexer & session manager
{ config, self, ... }:
let
  zellij = self.pkgs.zellij-wrapped.override {
    inherit (config.self.colors.default.zellij) theme;
  };
in
{
  user.packages = [ zellij ];
}
