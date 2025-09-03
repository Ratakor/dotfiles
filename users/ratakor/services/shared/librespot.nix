# Spotify client
{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) escapeShellArgs;
  inherit (lib.meta) getExe;

  # https://github.com/librespot-org/librespot/wiki/Options
  librespotOptions = {
    quiet = true;
    # disable-audio-cache = true;
    cache = "${config.xdg.cacheHome}/librespot";
    autoplay = "on";
    enable-volume-normalisation = true;
    name = "librespot@${osConfig.networking.hostName}";
    bitrate = 320;
    format = "F32";
    # backend = "pulseaudio";
    enable-oauth = true;
    initial-volume = 100;
    volume-ctrl = "fixed";
  };
in {
  home.packages = let
    args =
      mapAttrsToList (
        k: v:
          if v == null || v == false
          then ""
          else if v == true
          then "--${k}"
          else "--${k}=${toString v}"
      )
      librespotOptions;

    librespot = pkgs.writeShellApplication {
      name = "librespot";
      text = "exec ${getExe pkgs.librespot} ${escapeShellArgs args}";
    };
  in [
    librespot
  ];

  # This one works well if $XDG_CONFIG_HOME is set to ~/.config
  services.librespot = {
    enable = false;
    settings = librespotOptions;
  };
}
