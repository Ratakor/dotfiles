{
  username,
  pkgs,
  ...
}: {
  programs.senpai = {
    enable = true;
    # TODO
    config = {
      nickname = username;
      address = "libera.chat:6697";
      # password = "";
      # passowrd-cmd = "";
    };
  };
}
