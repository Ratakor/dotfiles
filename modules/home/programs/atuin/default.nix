# Better shell history
# I cba for now it's too complicated
{
  hm.programs.atuin = {
    enable = false;
    # Bind <C-R> and up-arrow to open the Atuin history.
    enableZshIntegration = true;
    daemon.enable = true;
    # flags = [];
    # forceOverwriteSettings = true;
    # settings = {};
    # themes = {};
  };
}
