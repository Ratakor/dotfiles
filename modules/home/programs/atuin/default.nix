# Better shell history
# I cba for now it's too complicated
{ config, ... }:
{
  hm.programs.atuin = {
    enable = false;
    # Bind <C-R> and up-arrow to open the Atuin history.
    enableZshIntegration = config.hm.programs.zsh.enable;
    daemon.enable = true;
    # flags = [];
    # forceOverwriteSettings = true;
    # settings = {};
    # themes = {};
  };
}
