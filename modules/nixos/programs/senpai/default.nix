# IRC Client
{ config, ... }:
{
  hm.programs.senpai = {
    enable = config.age.secrets ? irc;
    config = {
      nickname = config.user.description;
      address = "irctoday.com"; # "libera.chat:6697";
      password-cmd = [
        "cat"
        config.age.secrets.irc.path
      ];
    };
  };
}
