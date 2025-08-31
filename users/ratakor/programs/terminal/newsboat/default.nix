# RSS Reader
{
  config,
  pkgs,
  ...
}: {
  programs.newsboat = {
    enable = true;
    # TODO: port config
  };

  xdg.configFile."newsboat/config".source = ./config;
}
