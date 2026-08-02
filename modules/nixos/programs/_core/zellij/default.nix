# Terminal multiplexer & session manager
{ config, pkgs, ... }:
let
  zellij = pkgs.wrappers.zellij.override {
    inherit (config.self) colors;
  };
in
{
  user.packages = [ zellij ];
}
