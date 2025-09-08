# Spotify client
{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (self.lib) wrapWith mapShellArgsToList;

  librespot = wrapWith pkgs {
    basePackage = pkgs.librespot;

    # https://github.com/librespot-org/librespot/wiki/Options
    prependFlags = mapShellArgsToList {
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
  };
in {
  user.packages = [librespot];

  systemd.user.services.librespot = {
    enable = true;

    description = "Librespot (an open source Spotify client)";
    wantedBy = ["default.target"];

    serviceConfig = {
      ExecStart = getExe librespot;
      Restart = "always";
      RestartSec = 12;
    };
  };
}
