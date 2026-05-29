{
  hm.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
    # Enable direnv hook.
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}
