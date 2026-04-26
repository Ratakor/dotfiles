# Terminal multiplexer & session manager
{ config, pkgs, ... }:
let
  zellij = pkgs.wrappers.zellij.override {
    inherit (config.self.colors.default.zellij) theme;
  };
in
{
  user.packages = [ zellij ];
}
