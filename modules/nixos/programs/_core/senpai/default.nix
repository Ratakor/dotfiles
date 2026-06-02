# IRC Client
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;

  enabled = config.age.secrets ? irc;
in
{
  config = mkIf enabled {
    user.packages = [ pkgs.senpai ];

    hj.xdg.config.files."senpai/senpai.scfg".text = ''
      address irctoday.com
      nickname ${config.self.user.fullName}
      password-cmd cat ${config.age.secrets.irc.path}
    '';
  };
}
