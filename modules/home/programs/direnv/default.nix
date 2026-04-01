{ config, ... }:
{
  hm.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    # Enable direnv hook.
    enableZshIntegration = config.hm.programs.zsh.enable;
    enableNushellIntegration = config.hm.programs.nushell.enable;
  };
}
