{config, ...}: let
  dataHome = config.xdg.dataHome;
in {
  # TODO: applications

  home.file."${dataHome}/fonts" = {
    source = ./share/fonts;
    recursive = true;
  };

  # TODO: gnupg

  home.file."${dataHome}/emoji".source = ./share/emoji;
}
