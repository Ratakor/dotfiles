# spotify client
{
  config,
  osConfig,
  pkgs,
  self,
  ...
}: let
  inherit (builtins) toJSON;

  # https://github.com/librespot-org/librespot/wiki/Options
  librespotOptions = {
    quiet = true;
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
  home.packages = [
    # pkgs.librespot
    self.pkgs.librespot-cfg
  ];

  xdg.configFile."librespot/config.json".text = toJSON librespotOptions;

  services = {
    librespot = {
      enable = false; # TODO: org.freedesktop.systemd1.NoSuchUnit: Unit librespot.service not found.
      settings = librespotOptions;
    };
  };
}
