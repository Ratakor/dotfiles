{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.filesystem) listFiles;
  inherit (lib.modules) mkIf;
in
{
  hm.programs.anki = {
    enable = false;
    theme = "dark";
    profiles."User 1".sync = mkIf (config.age.secrets ? anki-key && config.age.secrets ? anki-user) {
      keyFile = config.age.secrets.anki-key.path;
      usernameFile = config.age.secrets.anki-user.path;
    };
    addons = listFiles ./plugins |> map (f: import f { inherit config pkgs; });
  };
}
