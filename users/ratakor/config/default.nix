{config, ...}: {
  programs = {
    # this is just PoC ofc for eza an alias may be a better idea
    eza = {
      enable = true;
      settings = {
        color = "auto";
        group-directories-first = true;
        hyperlink = true;
      };
    };
  };

  services = {
    librespot = {
      enable = true;
      settings = {
        quiet = true;
        # disable-audio-cache = true;
        # cache = "${config.xdg.cacheHome}/librespot"; # TODO: xdg
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
  };
}
