# RSS Reader
{ pkgs, ... }:
{
  user.packages = [ pkgs.newsboat ];

  hm.xdg = {
    configFile = {
      "newsboat/config".source = ./config;
      # "newsboat/urls".source = ./urls; # TODO
    };

    desktopEntries = {
      newsboat = {
        name = "Newsboat";
        exec = "newsboat";
        terminal = true;
      };
    };
  };
}
