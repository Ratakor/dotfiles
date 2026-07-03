# Git for zoomer ig
# Should this go in oxidation?
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  # false because better learn git really well first :p
  config = mkIf false {
    hm.programs.jujutsu = {
      enable = true;
      # https://github.com/jj-vcs/jj/blob/main/docs/config.md
      settings = {
        inherit (config.hm.programs.git.settings) user;
        signing = {
          backend = "gpg";
          behavior = "own";
        };
      };
    };

    hm.home.shellAliases = {
      jd = "jj desc";
      jf = "jj git fetch";
      jn = "jj new";
      jp = "jj git push";
      js = "jj st";
    };

    user.packages = with pkgs; [
      lazyjj
    ];
  };
}
