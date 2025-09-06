# Spotify client
{config, ...}: {
  wrap.services.librespot = {
    enable = true;
    service.enable = true;

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
  };
}
