# TODO: use and config this?
{ lib, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf false {
    services = {
      watt = {
        enable = true;
        # TODO
        settings = { };
      };

      # These services conflicts with watt
      power-profiles-daemon.enable = false;
      auto-cpufreq.enable = false;
    };
  };
}
