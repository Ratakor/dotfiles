# Better shell history
# I cba for now it's too complicated
{
  hm.programs.atuin = {
    enable = false;
    # Bind <C-R> and up-arrow to open the Atuin history.
    # TODO: currently using television but it doesn't seem to work on nushell
    enableZshIntegration = false;
    enableNushellIntegration = false;
    daemon.enable = true;
    # flags = [];
    # forceOverwriteSettings = true;
    # settings = {};
    # themes = {};
  };
}
