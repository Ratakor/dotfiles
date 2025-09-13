# Spotify client
{
  config,
  ...
}:
{
  hm.services.librespot = {
    enable = true;
    # https://github.com/librespot-org/librespot/wiki/Options
    settings = {
      quiet = true;
      # disable-audio-cache = true;
      cache = "${config.hm.xdg.cacheHome}/librespot";
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
}
