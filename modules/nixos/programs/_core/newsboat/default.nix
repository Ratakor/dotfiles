# RSS Reader
{ pkgs, ... }:
{
  user.packages = [ pkgs.newsboat ];

  hj.xdg.config.files = {
    "newsboat/config".source = ./config;
    # "newsboat/urls".source = ./urls; # managed via syncthing
  };
}
