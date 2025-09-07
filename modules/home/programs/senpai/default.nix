# IRC Client
{
  config,
  lib,
  pkgs,
  ...
}: let
  cat = lib.getExe' pkgs.coreutils "cat";
in {
  hm.programs.senpai = {
    enable = true;
    config = {
      nickname = config.user.description;
      address = "irctoday.com"; # "libera.chat:6697";
      password-cmd = [cat config.age.secrets.irc.path];
    };
  };
}
