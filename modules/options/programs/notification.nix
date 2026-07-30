# Now this should really be in services not programs BUT it actually make sense to put in programs
{ config, lib, ... }:
let
  inherit (lib.options) mkDesktopShellProgram;
in
mkDesktopShellProgram config "notification daemon" {
  values = [
    "dms"
    "mako"
    "noctalia"
  ];
  optionPath = [ "notification" ]; # because notificationDaemon was way too verbose
}
