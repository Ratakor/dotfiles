{
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib.filesystem) listFiles;
in
{
  hm.programs.anki = {
    enable = true;
    theme = "dark";
    sync = {
      passwordFile = config.age.secrets.anki-key.path;
      usernameFile = config.age.secrets.anki-user.path;
      # syncMedia = true;
      # networkTimeout = 60;
      # autoSync = true;
    };
    addons = listFiles ./plugins |> map (f: import f { inherit config pkgs; });
  };
}
