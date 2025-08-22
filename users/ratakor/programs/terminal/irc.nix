{
  config,
  pkgs,
  ...
}: {
  programs.senpai = {
    enable = true;
    config = {
      nickname = "Ratakor";
      address = "irctoday.com"; # "libera.chat:6697";
      password-cmd = ["cat" "/run/agenix/irc"]; # config.age.secrets.irc.path
    };
  };
}
