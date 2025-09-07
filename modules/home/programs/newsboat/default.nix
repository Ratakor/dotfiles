# RSS Reader
{
  hm.programs.newsboat = {
    enable = true;
    # TODO: port config
  };

  hm.xdg.configFile."newsboat/config".source = ./config;
}
