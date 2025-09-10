# Spotify client
{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.meta) getExe';
  inherit (self.lib) wrapWith;

  # https://github.com/librespot-org/librespot/wiki/Options
  settings = {
    quiet = true;
    # disable-audio-cache = true;
    cache = "${config.user.home}/${config.xdg.cache}/librespot";
    autoplay = "on";
    enable-volume-normalisation = true;
    name = "librespot@${config.networking.hostName}";
    bitrate = 320;
    format = "F32";
    # backend = "pulseaudio";
    enable-oauth = true;
    initial-volume = 100;
    volume-ctrl = "fixed";
  };

  librespot = wrapWith pkgs {
    basePackage = pkgs.librespot.overrideAttrs {
      # Override postFixup to prevent double wrapping
      # This little maneuver is gonna cost us 22 minutes
      # Maybe add `librespot-unwrapped` to packages so CI build it into cachix
      postFixup = "";
    };

    # This is what postFixup would normally do, hopefully we're using the same alsa-plugins
    env.ALSA_PLUGIN_DIR = {
      force = true;
      value = "${pkgs.alsa-plugins}/lib/alsa-lib";
    };

    # https://github.com/librespot-org/librespot/wiki/Options
    prependFlags =
      settings
      |> mapAttrsToList (
        k: v:
          if v == null || v == false
          then ""
          else if v == true
          then "--${k}"
          else "--${k}=${toString v}"
      );
  };
in {
  user.packages = [librespot];

  systemd.user.services.librespot = {
    enable = true;

    description = "Librespot (an open source Spotify client)";
    wantedBy = ["default.target"];

    serviceConfig = {
      ExecStart = getExe' librespot "librespot";
      Restart = "always";
      RestartSec = 12;
    };
  };
}
