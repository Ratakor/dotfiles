{config, ...}: let
  configHome = config.xdg.configHome;
in {
  home.file."${configHome}/fastfetch" = {
    source = ./etc/fastfetch;
    recursive = true;
  };

  home.file."${configHome}/fontconfig" = {
    source = ./etc/fontconfig;
    recursive = true;
  };

  # TODO: glow
  # TODO: gtk-3.0

  # home.file."${configHome}/librespot" = {
  #   source = ./etc/librespot;
  #   recursive = true;
  # };

  # TODO: pipewire

  home.file."${configHome}/quand" = {
    source = ./etc/quand;
    recursive = true;
  };

  home.file."${configHome}/ytfzf" = {
    source = ./etc/ytfzf;
    recursive = true;
  };

  # TODO: crontab

  # TODO: syncthing

  # NOTE: this can be really useful to provide XDG_CONFIG_HOME etc where there is no env var interpretation
  # home.file.".xxx".text = ''
  #     xxx
  # '';
}
