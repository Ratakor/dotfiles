{config, ...}: let
  dataHome = config.xdg.dataHome;
in {
  # TODO: applications

  # TODO: gnupg

  home.file."${dataHome}/emoji".source = ./share/emoji;
}
