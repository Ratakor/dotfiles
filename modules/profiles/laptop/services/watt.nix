# TODO: use and config this?
{
  lib,
  pkgs,
  sources,
  ...
}:
let
  # module is not enabled by default (that is good) but package is wrong
  module = import "${sources.watt}/nix/module.nix" { };
in
{
  imports = [ module ];

  config = lib.mkIf false {
    services = {
      watt = {
        enable = true;
        package = pkgs.watt; # thank you for being lazy mr nix
        # TODO
        settings = { };
      };
      # These services conflicts with watt
      power-profiles-daemon.enable = false;
      auto-cpufreq.enable = false;
    };
  };
}
