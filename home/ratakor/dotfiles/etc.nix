{
  config,
  ...
}: let
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

  home.file."${configHome}/gitui" = {
    source = ./etc/gitui;
    recursive = true;
  };

  # TODO: glow
  # TODO: gtk-3.0

  # home.file."${configHome}/librespot" = {
  #   source = ./etc/librespot;
  #   recursive = true;
  # };

  home.file."${configHome}/mpv" = {
    source = ./etc/mpv;
    recursive = true;
  };

  home.file."${configHome}/newsboat" = {
    source = ./etc/newsboat;
    recursive = true;
  };

  home.file."${configHome}/nvim" = {
    source = ./etc/nvim;
    recursive = true;
  };

  # TODO: pipewire

  home.file."${configHome}/python" = {
    source = ./etc/python;
    recursive = true;
  };

  home.file."${configHome}/quand" = {
    source = ./etc/quand;
    recursive = true;
  };

  home.file."${configHome}/river" = {
    source = ./etc/river;
    recursive = true;
  };

  home.file."${configHome}/waybar" = {
    source = ./etc/waybar;
    recursive = true;
  };

  home.file."${configHome}/yazi" = {
    source = ./etc/yazi;
    recursive = true;
  };

  home.file."${configHome}/ytfzf" = {
    source = ./etc/ytfzf;
    recursive = true;
  };

  # this one is probably good
  # home.file."${configHome}/zathura" = {
  #   source = ./etc/zathura;
  #   recursive = true;
  # };

  home.file."${configHome}/zellij" = {
    source = ./etc/zellij;
    recursive = true;
  };

  home.file."${configHome}/zsh" = {
    source = ./etc/zsh;
    recursive = true;
  };

  # TODO: crontab

  # TODO: mimeapps.list

  # TODO: npmrc

  # TODO: syncthing

  # NOTE: this can be really useful to provide XDG_CONFIG_HOME etc where there is no env var interpretation
  # home.file.".xxx".text = ''
  #     xxx
  # '';
}
