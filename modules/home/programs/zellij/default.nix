# Terminal multiplexer & session manager
{ config, self, ... }:
let
  zellij = self.pkgs.zellij-wrapped.override {
    theme = config.self.colorscheme;
  };
in
{
  user.packages = [ zellij ];
}
