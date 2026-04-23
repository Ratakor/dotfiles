# Git for zoomer ig
# Should this go in oxidation?
{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  hm.programs.jujutsu = {
    enable = false; # better learn git really well first tbh
    # https://github.com/jj-vcs/jj/blob/main/docs/config.md
    settings = {
      inherit (config.hm.programs.git.settings) user;
      signing = {
        backend = "gpg";
        behavior = "own";
      };

    };
  };

  hm.home.shellAliases = mkIf config.hm.programs.jujutsu.enable {
    jd = "jj desc";
    jf = "jj git fetch";
    jn = "jj new";
    jp = "jj git push";
    js = "jj st";
  };
}
