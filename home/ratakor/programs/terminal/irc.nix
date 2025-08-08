{
  config,
  mylib,
  pkgs,
  username,
  ...
}: {
  programs.senpai = {
    enable = true;
    config = {
      nickname = mylib.capitalize username;
      address = "irctoday.com"; # "libera.chat:6697";
      # TODO
      # password = "";
      # passowrd-cmd = ["cat" age.secrets.irc.path];
    };
  };
}
