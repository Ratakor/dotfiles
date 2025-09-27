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
      keyFile = config.age.secrets.anki-key.path;
      usernameFile = config.age.secrets.anki-user.path;
    };
    addons = listFiles ./plugins |> map (f: import f { inherit config pkgs; });
  };
}
