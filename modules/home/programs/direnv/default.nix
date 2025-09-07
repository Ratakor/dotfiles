{
  hm.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true; # adds a hook to enable direnv with zsh
    silent = true;
  };
}
