# https://yalter.github.io/niri/Configuration:-Include
{ config, lib, ... }:
let
  inherit (builtins) concatStringsSep;
  inherit (lib.strings) optionalString;

  XDG_CONFIG_HOME = config.hm.xdg.configHome;
  prg = config.self.programs;
in
concatStringsSep "\n" [
  (optionalString prg.desktopShell.noctalia.enable /* kdl */ ''
    include optional=true "${XDG_CONFIG_HOME}/niri/noctalia.kdl"
  '')
  (optionalString prg.desktopShell.dms.enable /* kdl */ ''
    // include optional=true "${XDG_CONFIG_HOME}/dms/alttab.kdl"
    // include optional=true "${XDG_CONFIG_HOME}/dms/binds.kdl"
    include optional=true "${XDG_CONFIG_HOME}/dms/colors.kdl"
    // include optional=true "${XDG_CONFIG_HOME}/dms/cursor.kdl"
    // include optional=true "${XDG_CONFIG_HOME}/dms/layout.kdl"
    // include optional=true "${XDG_CONFIG_HOME}/dms/outputs.kdl"
    // include optional=true "${XDG_CONFIG_HOME}/dms/windowrules.kdl"
    include optional=true "${XDG_CONFIG_HOME}/dms/wpblur.kdl"
  '')
]
