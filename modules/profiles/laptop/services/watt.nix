# TODO: use and config this?
# https://github.com/NotAShelf/watt/blob/main/docs/configuring.md
# https://github.com/NotAShelf/watt/blob/main/watt/config.toml
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
