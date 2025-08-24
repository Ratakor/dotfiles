{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  cat = lib.getExe' pkgs.coreutils "cat";
in {
  programs.senpai = {
    enable = true;
    config = {
      nickname = "Ratakor";
      address = "irctoday.com"; # "libera.chat:6697";
      password-cmd = [cat osConfig.age.secrets.irc.path];
    };
  };
}
