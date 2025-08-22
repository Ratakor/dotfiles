{colors, ...}: {
  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      show-failed-attempt = true;
      indicator-caps-lock = true;
      indicator-radius = 100;
      font = "monospace";
      scaling = "fill";
      # TODO: colors
    };
  };
}
